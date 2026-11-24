#!/usr/bin/env python3
"""
udon2ml.py — Prototype UDON <-> OCaml ADT compiler for DDD Bounded Contexts.

Compiles:
  1. UDON schema files (*.schema.ud) -> OCaml .mli + .ml modules
     (enums, inline-record variants, value-object records, keyed entities with
      abstract covariant phantom-typed IDs, trait axes, bounded context imports)
  2. UDON data files (*.ud) -> OCaml .ml + .mli data modules with `# line "file.ud"`
     directives so `ocamlc` reports type, reference, trait, and boundary errors
     at the exact `.ud` source line.

Designed for Spike 2 (UDON as a DDD Schema & Algebraic Data Language).
"""

from __future__ import annotations
from dataclasses import dataclass, field
from pathlib import Path
import re
import sys
from typing import Optional

# ---------------------------------------------------------------------------
# OCaml identifier normalization & keyword escaping
# ---------------------------------------------------------------------------

OCAML_KEYWORDS = {
    "and", "as", "assert", "asr", "begin", "class", "constraint", "do", "done",
    "downto", "else", "end", "exception", "external", "false", "for", "fun",
    "function", "functor", "if", "in", "include", "inherit", "initializer",
    "land", "lazy", "let", "lor", "lsl", "lsr", "lxor", "match", "method",
    "mod", "module", "mutable", "new", "nonrec", "object", "of", "open", "or",
    "private", "rec", "sig", "struct", "then", "to", "true", "try", "type",
    "val", "virtual", "when", "while", "with", "ref",
}

def ml_ident(name: str) -> str:
    """Convert UDON kebab-case name to a valid OCaml lowercase identifier."""
    s = name.strip().replace("-", "_").replace(".", "_")
    s = re.sub(r"[^A-Za-z0-9_]", "_", s)
    if not s or not (s[0].isalpha() or s[0] == "_"):
        s = "u_" + s
    s = s[0].lower() + s[1:]
    if s in OCAML_KEYWORDS:
        s = s + "_"
    return s

def ml_ctor(name: str) -> str:
    """Convert UDON kebab-case name to an OCaml capitalized constructor / module name."""
    s = name.strip().replace("-", "_").replace(".", "_")
    s = re.sub(r"[^A-Za-z0-9_]", "_", s)
    if not s or not s[0].isalpha():
        s = "U_" + s
    return s[0].upper() + s[1:]

def ml_string(s: str) -> str:
    """Escape a Python string as an OCaml string literal."""
    out = s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n").replace("\t", "\\t")
    return f'"{out}"'

# ---------------------------------------------------------------------------
# Raw UDON AST (faithful to v2 spec/def/element.md: name?, attrs, ordered children)
# ---------------------------------------------------------------------------

@dataclass
class AttrVal:
    raw: str
    line: int
    elem_children: list["UdonElement"] = field(default_factory=list)

@dataclass
class UdonText:
    text: str
    line: int
    inline_refs: list[tuple[str, int]] = field(default_factory=list)  # (ref_slug, line)

@dataclass
class UdonElement:
    name: Optional[str]          # None for anonymous element (def/element.md!)
    key: Optional[str]           # $key from [id]
    extra_keys: list[str]        # if multiple [k1][k2] appeared (e.g. def-binding.ud)
    traits: list[str]            # $traits from .a.b
    main: Optional[str]          # $main from own-line text
    attrs: dict[str, list[AttrVal]]  # attr_name -> ordered values for that name
    children: list["UdonElement | UdonText"]  # strictly ordered child nodes
    file: str
    line: int

# ---------------------------------------------------------------------------
# Indentation-aware UDON Parser
# ---------------------------------------------------------------------------

def strip_inline_comment(line: str) -> str:
    """Remove trailing `; ...` comment outside double-quoted strings."""
    in_str = False
    esc = False
    for i, ch in enumerate(line):
        if esc:
            esc = False
            continue
        if ch == "\\" and in_str:
            esc = True
            continue
        if ch == '"':
            in_str = not in_str
            continue
        if ch == ";" and not in_str:
            # Only treat `;` as comment if at start or preceded by whitespace
            if i == 0 or line[i - 1].isspace():
                return line[:i].rstrip()
    return line.rstrip()

def extract_inline_refs(text: str, line_no: int) -> list[tuple[str, int]]:
    """Extract @{slug} or @[slug] inline references from prose text."""
    refs: list[tuple[str, int]] = []
    for m in re.finditer(r"@\{([A-Za-z0-9_.:-]+)\}|@\[([A-Za-z0-9_.:-]+)\]", text):
        slug = m.group(1) or m.group(2)
        refs.append((slug, line_no))
    return refs

def tokenize_inline_attrs(rest: str, line_no: int) -> tuple[list[tuple[str, str]], Optional[str]]:
    """
    Parse inline `:attr val` pairs from the remainder of an element header line.
    Stops at `\\ ` (explicit $main separator) or if the remainder doesn't start with `:`.
    Returns ([(attr_name, raw_val), ...], main_text_or_None).
    """
    s = rest.lstrip()
    if not s:
        return [], None
    if not s.startswith(":"):
        if s.startswith("\\ "):
            return [], s[2:].strip()
        if s == "\\":
            return [], ""
        return [], s

    attrs: list[tuple[str, str]] = []
    i = 0
    n = len(s)
    while i < n:
        while i < n and s[i].isspace():
            i += 1
        if i >= n:
            break
        if s[i] == "\\":
            # Explicit $main separator
            main_part = s[i + 1:].strip()
            return attrs, main_part
        if s[i] != ":":
            # Bare trailing $main text after attributes
            return attrs, s[i:].strip()
        # Read attribute name
        i += 1  # skip ':'
        start = i
        while i < n and not s[i].isspace():
            i += 1
        key = s[start:i]
        while i < n and s[i].isspace():
            i += 1
        if i >= n or s[i] == ":" or s[i] == "\\":
            # Flag-like boolean attribute with no explicit value
            attrs.append((key, "true"))
            continue
        # Read attribute value: quoted string, [list], {card}, or single token
        if s[i] == '"':
            j = i + 1
            esc = False
            while j < n:
                if esc:
                    esc = False
                elif s[j] == "\\":
                    esc = True
                elif s[j] == '"':
                    j += 1
                    break
                j += 1
            val = s[i:j]
            i = j
        elif s[i] == "[":
            depth = 0
            j = i
            in_q = False
            esc = False
            while j < n:
                ch = s[j]
                if esc:
                    esc = False
                elif ch == "\\" and in_q:
                    esc = True
                elif ch == '"':
                    in_q = not in_q
                elif not in_q:
                    if ch == "[":
                        depth += 1
                    elif ch == "]":
                        depth -= 1
                        if depth == 0:
                            j += 1
                            break
                j += 1
            val = s[i:j]
            i = j
        elif s[i] == "{":
            j = s.find("}", i)
            if j == -1:
                val = s[i:]
                i = n
            else:
                val = s[i:j + 1]
                i = j + 1
        else:
            start_v = i
            while i < n and not s[i].isspace():
                i += 1
            val = s[start_v:i]
        attrs.append((key, val))
    return attrs, None

def parse_element_header(content: str, file: str, line_no: int) -> UdonElement:
    """Parse `|name[key].t1.t2 :a 1 :b 2 \\ main` (or anonymous `|[id]`, `|`, etc.)."""
    assert content.startswith("|")
    s = content[1:]
    i = 0
    n = len(s)

    # Read optional element name (up to whitespace, [, ., :, \)
    start = i
    while i < n and not s[i].isspace() and s[i] not in "[.:\\":
        i += 1
    name: Optional[str] = s[start:i] if i > start else None

    keys: list[str] = []
    traits: list[str] = []

    while i < n and s[i] in "[.":
        if s[i] == "[":
            end = s.find("]", i + 1)
            if end == -1:
                raise SyntaxError(f"{file}:{line_no}: unclosed '[' in element header")
            keys.append(s[i + 1:end].strip())
            i = end + 1
        elif s[i] == ".":
            i += 1
            t_start = i
            while i < n and not s[i].isspace() and s[i] not in "[.:\\":
                i += 1
            trait = s[t_start:i]
            if not trait:
                raise SyntaxError(f"{file}:{line_no}: empty trait after '.'")
            traits.append(trait)

    rest = s[i:]
    inline_attrs, main = tokenize_inline_attrs(rest, line_no)
    attrs: dict[str, list[AttrVal]] = {}
    for k, v in inline_attrs:
        attrs.setdefault(k, []).append(AttrVal(raw=v, line=line_no))

    key = keys[0] if keys else None
    extra_keys = keys[1:] if len(keys) > 1 else []
    return UdonElement(
        name=name,
        key=key,
        extra_keys=extra_keys,
        traits=traits,
        main=main,
        attrs=attrs,
        children=[],
        file=file,
        line=line_no,
    )

def parse_udon(text: str, filename: str) -> list[UdonElement | UdonText]:
    """Parse a UDON partial into its ordered root nodes."""
    roots: list[UdonElement | UdonText] = []
    # Stack entries: (indent, kind, target)
    # kind == "elem": target is UdonElement
    # kind == "attr": target is AttrVal (accepting element children)
    stack: list[tuple[int, str, object]] = []

    raw_lines = text.splitlines()
    for idx, raw_line in enumerate(raw_lines, start=1):
        stripped = strip_inline_comment(raw_line)
        if not stripped.strip():
            continue
        indent = len(stripped) - len(stripped.lstrip(" "))
        content = stripped.lstrip(" ")

        while stack and indent <= stack[-1][0]:
            stack.pop()

        if content.startswith("|"):
            elem = parse_element_header(content, filename, idx)
            if not stack:
                roots.append(elem)
            else:
                _, pkind, parent = stack[-1]
                if pkind == "elem":
                    parent.children.append(elem)  # type: ignore[attr-defined]
                elif pkind == "attr":
                    parent.elem_children.append(elem)  # type: ignore[attr-defined]
            stack.append((indent, "elem", elem))

        elif content.startswith(":"):
            if not stack or stack[-1][1] != "elem":
                raise SyntaxError(f"{filename}:{idx}: attribute line outside element: {content}")
            parent_elem: UdonElement = stack[-1][2]  # type: ignore[assignment]
            parts = content[1:].split(None, 1)
            attr_name = parts[0]
            attr_raw = parts[1].strip() if len(parts) > 1 else ""
            av = AttrVal(raw=attr_raw, line=idx)
            parent_elem.attrs.setdefault(attr_name, []).append(av)
            if attr_raw == "":
                # Element-valued attribute block!
                stack.append((indent, "attr", av))

        else:
            # Prose text node
            txt = UdonText(text=content, line=idx, inline_refs=extract_inline_refs(content, idx))
            if not stack:
                roots.append(txt)
            else:
                _, pkind, parent = stack[-1]
                if pkind == "elem":
                    parent.children.append(txt)  # type: ignore[attr-defined]
                elif pkind == "attr":
                    # Multi-line text inside attribute value
                    av_parent: AttrVal = parent  # type: ignore[assignment]
                    av_parent.raw = (av_parent.raw + "\n" + content).strip()

    return roots

# ---------------------------------------------------------------------------
# Schema IR (Domain-Driven Design Bounded Context)
# ---------------------------------------------------------------------------

@dataclass
class TypeRef:
    base: str                  # primitive, enum/record/variant name, or entity ref
    modifier: str = ""         # "", "?", "*", "+"
    is_entity_ref: bool = False
    ref_context: Optional[str] = None  # cross-context module name (if `@ctx:entity`)
    ref_trait: Optional[str] = None    # phantom trait requirement (if `@entity.trait`)

def parse_type_ref(raw: str) -> TypeRef:
    raw = raw.strip()
    mod = ""
    if raw and raw[-1] in "?*+":
        mod = raw[-1]
        raw = raw[:-1]
    if raw.startswith("@"):
        body = raw[1:]
        ref_ctx = None
        if ":" in body:
            ref_ctx, body = body.split(":", 1)
        ref_trait = None
        if "." in body:
            body, ref_trait = body.split(".", 1)
        return TypeRef(
            base=body,
            modifier=mod,
            is_entity_ref=True,
            ref_context=ref_ctx,
            ref_trait=ref_trait,
        )
    return TypeRef(base=raw, modifier=mod)

@dataclass
class FieldSpec:
    name: str
    tref: TypeRef
    line: int

@dataclass
class EnumSpec:
    name: str
    doc: str
    cases: list[tuple[str, str]]  # (case_name, doc)
    line: int

@dataclass
class RecordSpec:
    name: str
    doc: str
    fields: list[FieldSpec]
    line: int

@dataclass
class VariantCaseSpec:
    name: str
    doc: str
    fields: list[FieldSpec]
    line: int

@dataclass
class VariantSpec:
    name: str
    doc: str
    cases: list[VariantCaseSpec]
    line: int

@dataclass
class TraitAxisSpec:
    name: str
    values: list[tuple[str, str]]  # (trait_name, doc)
    line: int

@dataclass
class EntitySpec:
    name: str
    doc: str
    trait_axis: Optional[TraitAxisSpec]
    additive_traits: list[tuple[str, str]]
    fields: list[FieldSpec]
    child_slots: list[tuple[str, str]]      # (udon_elem_name, record_or_variant_name)
    prose_ref_entity: Optional[str]         # if |prose @entity declared
    ordered_children_type: Optional[str]    # if |children-ordered <variant> declared
    line: int

@dataclass
class ContextSchema:
    name: str
    doc: str
    uses: list[str]
    enums: dict[str, EnumSpec]
    records: dict[str, RecordSpec]
    variants: dict[str, VariantSpec]
    entities: dict[str, EntitySpec]
    file: str

def parse_list_tokens(raw: str) -> list[str]:
    """Parse UDON `[a b "c d"]` list literal into raw item strings."""
    s = raw.strip()
    if s.startswith("[") and s.endswith("]"):
        s = s[1:-1].strip()
    if not s:
        return []
    tokens: list[str] = []
    i = 0
    n = len(s)
    while i < n:
        while i < n and s[i].isspace():
            i += 1
        if i >= n:
            break
        if s[i] == '"':
            j = i + 1
            esc = False
            while j < n:
                if esc:
                    esc = False
                elif s[j] == "\\":
                    esc = True
                elif s[j] == '"':
                    j += 1
                    break
                j += 1
            tokens.append(s[i:j])
            i = j
        else:
            j = i
            while j < n and not s[j].isspace():
                j += 1
            tokens.append(s[i:j])
            i = j
    return tokens

def load_schema(path: Path) -> ContextSchema:
    roots = parse_udon(path.read_text(), str(path))
    ctx_elems = [r for r in roots if isinstance(r, UdonElement) and r.name == "context"]
    if len(ctx_elems) != 1:
        raise ValueError(f"{path}: expected exactly one top-level |context[name] element")
    ctx = ctx_elems[0]
    if not ctx.key:
        raise ValueError(f"{path}:{ctx.line}: |context must have a [name] key")

    uses: list[str] = []
    if "uses" in ctx.attrs:
        for av in ctx.attrs["uses"]:
            uses.extend(parse_list_tokens(av.raw))

    enums: dict[str, EnumSpec] = {}
    records: dict[str, RecordSpec] = {}
    variants: dict[str, VariantSpec] = {}
    entities: dict[str, EntitySpec] = {}

    for child in ctx.children:
        if not isinstance(child, UdonElement):
            continue
        if child.name == "enum":
            assert child.key
            cases = []
            for c in child.children:
                if isinstance(c, UdonElement) and c.name:
                    cases.append((c.name, c.main or ""))
            enums[child.key] = EnumSpec(child.key, child.main or "", cases, child.line)

        elif child.name == "record":
            assert child.key
            fields = [
                FieldSpec(fname, parse_type_ref(vals[-1].raw), vals[-1].line)
                for fname, vals in child.attrs.items()
            ]
            records[child.key] = RecordSpec(child.key, child.main or "", fields, child.line)

        elif child.name == "variant":
            assert child.key
            vcases = []
            for c in child.children:
                if isinstance(c, UdonElement) and c.name:
                    vfields = [
                        FieldSpec(fname, parse_type_ref(vals[-1].raw), vals[-1].line)
                        for fname, vals in c.attrs.items()
                    ]
                    vcases.append(VariantCaseSpec(c.name, c.main or "", vfields, c.line))
            variants[child.key] = VariantSpec(child.key, child.main or "", vcases, child.line)

        elif child.name == "entity":
            assert child.key
            axis: Optional[TraitAxisSpec] = None
            additive: list[tuple[str, str]] = []
            child_slots: list[tuple[str, str]] = []
            prose_ref: Optional[str] = None
            ordered_child_type: Optional[str] = None

            efields = [
                FieldSpec(fname, parse_type_ref(vals[-1].raw), vals[-1].line)
                for fname, vals in child.attrs.items()
            ]
            for c in child.children:
                if not isinstance(c, UdonElement):
                    continue
                if c.name == "trait-axis":
                    assert c.key
                    tvals = [
                        (tc.name, tc.main or "")
                        for tc in c.children
                        if isinstance(tc, UdonElement) and tc.name
                    ]
                    axis = TraitAxisSpec(c.key, tvals, c.line)
                elif c.name == "traits":
                    for tc in c.children:
                        if isinstance(tc, UdonElement) and tc.name:
                            additive.append((tc.name, tc.main or ""))
                elif c.name == "children":
                    for cc in c.children:
                        if isinstance(cc, UdonElement) and cc.name:
                            if cc.name == "prose":
                                target = (cc.main or "").strip()
                                prose_ref = target[1:] if target.startswith("@") else target
                            else:
                                child_slots.append((cc.name, (cc.main or "").strip()))
                elif c.name == "children-ordered":
                    ordered_child_type = (c.main or "").strip()

            entities[child.key] = EntitySpec(
                name=child.key,
                doc=child.main or "",
                trait_axis=axis,
                additive_traits=additive,
                fields=efields,
                child_slots=child_slots,
                prose_ref_entity=prose_ref,
                ordered_children_type=ordered_child_type,
                line=child.line,
            )

    return ContextSchema(
        name=ctx.key,
        doc=ctx.main or "",
        uses=uses,
        enums=enums,
        records=records,
        variants=variants,
        entities=entities,
        file=str(path),
    )

# ---------------------------------------------------------------------------
# Schema -> OCaml (.mli + .ml) Codegen
# ---------------------------------------------------------------------------

def ocaml_type_expr(tref: TypeRef, schema: ContextSchema, all_schemas: dict[str, ContextSchema]) -> str:
    if tref.is_entity_ref:
        if tref.ref_context:
            ctx_mod = ml_ctor(tref.ref_context)
            ent_mod = ml_ctor(tref.base)
            target_schema = all_schemas[tref.ref_context]
            ent = target_schema.entities[tref.base]
            if tref.ref_trait:
                base_ty = f"[ `{ml_ctor(tref.ref_trait)} ] {ctx_mod}.{ent_mod}.id"
            elif ent.trait_axis:
                base_ty = f"{ctx_mod}.{ent_mod}.any_id"
            else:
                base_ty = f"{ctx_mod}.{ent_mod}.id"
        else:
            ent = schema.entities[tref.base]
            id_ty = f"{ml_ident(tref.base)}_id"
            any_ty = f"{ml_ident(tref.base)}_any_id"
            if tref.ref_trait:
                base_ty = f"[ `{ml_ctor(tref.ref_trait)} ] {id_ty}"
            elif ent.trait_axis:
                base_ty = any_ty
            else:
                base_ty = id_ty
    else:
        if tref.base in ("string", "int", "bool"):
            base_ty = tref.base
        elif tref.base == "card":
            base_ty = "card"
        else:
            base_ty = ml_ident(tref.base)

    if tref.modifier == "?":
        return f"{base_ty} option"
    if tref.modifier == "*":
        return f"{base_ty} list"
    if tref.modifier == "+":
        return f"{base_ty} nonempty"
    return base_ty

def check_field_collisions(fields: list[FieldSpec], owner: str, file: str) -> None:
    seen: dict[str, str] = {}
    for f in fields:
        m = ml_ident(f.name)
        if m in seen and seen[m] != f.name:
            raise ValueError(
                f"{file}:{f.line}: identifier collision in {owner}: "
                f"':{seen[m]}' and ':{f.name}' both lower to OCaml '{m}'"
            )
        seen[m] = f.name

def emit_schema_ocaml(
    schema: ContextSchema,
    all_schemas: dict[str, ContextSchema],
    out_dir: Path,
) -> tuple[Path, Path]:
    mod_file = ml_ident(schema.name)
    mli_path = out_dir / f"{mod_file}.mli"
    ml_path = out_dir / f"{mod_file}.ml"

    mli: list[str] = [
        f"(* Generated from {schema.file} — Bounded Context: {schema.name} *)",
        f"(* {schema.doc} *)",
        "",
        "type 'a nonempty = Nonempty of 'a * 'a list",
        "type card = { min : int; max : int option }",
        "val card_to_string : card -> string",
        "val nonempty_to_list : 'a nonempty -> 'a list",
        "",
    ]
    ml: list[str] = [
        f"(* Generated from {schema.file} — Bounded Context: {schema.name} *)",
        "",
        "type 'a nonempty = Nonempty of 'a * 'a list",
        "type card = { min : int; max : int option }",
        'let card_to_string c = Printf.sprintf "{%d,%s}" c.min (match c.max with None -> "N" | Some m -> string_of_int m)',
        "let nonempty_to_list (Nonempty (h, t)) = h :: t",
        "",
    ]

    # Phase 1: Abstract covariant phantom-typed Entity IDs (declared first so records/variants can reference them!)
    mli.append("(* --- Phase 1: Abstract Entity IDs (Bounded Context boundary) --- *)")
    ml.append("(* --- Phase 1: Abstract Entity IDs --- *)")
    for ent in schema.entities.values():
        id_ty = f"{ml_ident(ent.name)}_id"
        if ent.trait_axis:
            tags = " | ".join(f"`{ml_ctor(t)}" for t, _ in ent.trait_axis.values)
            any_ty = f"{ml_ident(ent.name)}_any_id"
            mli.append(f"type +'s {id_ty}")
            mli.append(f"type {any_ty} = [ {tags} ] {id_ty}")
            ml.append(f"type +'s {id_ty} = string")
            ml.append(f"type {any_ty} = [ {tags} ] {id_ty}")
        else:
            mli.append(f"type {id_ty}")
            ml.append(f"type {id_ty} = string")
    mli.append("")
    ml.append("")

    # Phase 2: Enums
    if schema.enums:
        mli.append("(* --- Phase 2: Ubiquitous Language Enums --- *)")
        ml.append("(* --- Phase 2: Ubiquitous Language Enums --- *)")
        for en in schema.enums.values():
            tname = ml_ident(en.name)
            cases_str = "\n  | ".join(ml_ctor(c) for c, _ in en.cases)
            block = f"type {tname} =\n  | {cases_str}"
            mli.append(block)
            ml.append(block)
            mli.append(f"val {tname}_to_string : {tname} -> string")
            to_s_arms = "\n  | ".join(f'{ml_ctor(c)} -> "{c}"' for c, _ in en.cases)
            ml.append(f"let {tname}_to_string = function\n  | {to_s_arms}")
            mli.append("")
            ml.append("")

    # Phase 3: Records & Variants (mutually recursive group so order in .ud never breaks OCaml!)
    rv_defs: list[str] = []
    for rec in schema.records.values():
        check_field_collisions(rec.fields, f"record[{rec.name}]", schema.file)
        f_lines = [
            f"  {ml_ident(f.name)} : {ocaml_type_expr(f.tref, schema, all_schemas)};"
            for f in rec.fields
        ]
        rv_defs.append(f"{ml_ident(rec.name)} = {{\n" + "\n".join(f_lines) + "\n}")

    for var in schema.variants.values():
        c_lines = []
        for vc in var.cases:
            check_field_collisions(vc.fields, f"variant[{var.name}].{vc.name}", schema.file)
            if not vc.fields:
                c_lines.append(f"  | {ml_ctor(vc.name)}")
            else:
                vf_lines = "; ".join(
                    f"{ml_ident(f.name)} : {ocaml_type_expr(f.tref, schema, all_schemas)}"
                    for f in vc.fields
                )
                c_lines.append(f"  | {ml_ctor(vc.name)} of {{ {vf_lines} }}")
        rv_defs.append(f"{ml_ident(var.name)} =\n" + "\n".join(c_lines))

    if rv_defs:
        mli.append("(* --- Phase 3: Value Objects & Algebraic Variants --- *)")
        ml.append("(* --- Phase 3: Value Objects & Algebraic Variants --- *)")
        joined = "\nand ".join(rv_defs)
        mli.append("type " + joined)
        ml.append("type " + joined)
        mli.append("")
        ml.append("")

    # Phase 4: Entity Modules (exporting typed IDs, traits, entity record, and minting witnesses)
    mli.append("(* --- Phase 4: Keyed Entities --- *)")
    ml.append("(* --- Phase 4: Keyed Entities --- *)")
    for ent in schema.entities.values():
        check_field_collisions(ent.fields, f"entity[{ent.name}]", schema.file)
        emod = ml_ctor(ent.name)
        id_ty = f"{ml_ident(ent.name)}_id"
        any_ty = f"{ml_ident(ent.name)}_any_id"

        rec_fields: list[str] = []
        if ent.trait_axis:
            rec_fields.append(f"    id : any_id;")
            rec_fields.append(f"    {ml_ident(ent.trait_axis.name)} : {ml_ident(ent.trait_axis.name)};")
        else:
            rec_fields.append(f"    id : id;")

        if ent.additive_traits:
            rec_fields.append("    traits : trait list;")

        for f in ent.fields:
            rec_fields.append(f"    {ml_ident(f.name)} : {ocaml_type_expr(f.tref, schema, all_schemas)};")

        for slot_elem, slot_ty in ent.child_slots:
            rec_fields.append(f"    {ml_ident(slot_elem)}_items : {ml_ident(slot_ty)} list;")

        if ent.ordered_children_type:
            rec_fields.append(f"    children : {ml_ident(ent.ordered_children_type)} list;")

        if ent.prose_ref_entity:
            ref_ent = schema.entities[ent.prose_ref_entity]
            ref_ty = f"{ml_ident(ent.prose_ref_entity)}_any_id" if ref_ent.trait_axis else f"{ml_ident(ent.prose_ref_entity)}_id"
            rec_fields.append("    prose : string list;")
            rec_fields.append(f"    prose_refs : {ref_ty} list;")

        # Signature
        mli.append(f"module {emod} : sig")
        if ent.trait_axis:
            ax_name = ml_ident(ent.trait_axis.name)
            ax_cases = " | ".join(ml_ctor(v) for v, _ in ent.trait_axis.values)
            mli.append(f"  type {ax_name} = {ax_cases}")
            mli.append(f"  val {ax_name}_to_string : {ax_name} -> string")
            mli.append(f"  type +'s id = 's {id_ty}")
            mli.append(f"  type any_id = {any_ty}")
            mli.append("  val id_name : 's id -> string")
            for v, _ in ent.trait_axis.values:
                mli.append(f"  val mint_{ml_ident(v)} : string -> [ `{ml_ctor(v)} ] id")
        else:
            mli.append(f"  type id = {id_ty}")
            mli.append("  val id_name : id -> string")
            mli.append("  val mint : string -> id")

        if ent.additive_traits:
            tr_cases = " | ".join(ml_ctor(t) for t, _ in ent.additive_traits)
            mli.append(f"  type trait = {tr_cases}")
            mli.append("  val trait_to_string : trait -> string")

        mli.append("  type t = {")
        mli.extend(rec_fields)
        mli.append("  }")
        mli.append("end")
        mli.append("")

        # Implementation
        ml.append(f"module {emod} = struct")
        if ent.trait_axis:
            ax_name = ml_ident(ent.trait_axis.name)
            ax_cases = " | ".join(ml_ctor(v) for v, _ in ent.trait_axis.values)
            ml.append(f"  type {ax_name} = {ax_cases}")
            arms = " | ".join(f'{ml_ctor(v)} -> "{v}"' for v, _ in ent.trait_axis.values)
            ml.append(f"  let {ax_name}_to_string = function {arms}")
            ml.append(f"  type +'s id = 's {id_ty}")
            ml.append(f"  type any_id = {any_ty}")
            ml.append("  let id_name s = s")
            for v, _ in ent.trait_axis.values:
                ml.append(f"  let mint_{ml_ident(v)} s = s")
        else:
            ml.append(f"  type id = {id_ty}")
            ml.append("  let id_name s = s")
            ml.append("  let mint s = s")

        if ent.additive_traits:
            tr_cases = " | ".join(ml_ctor(t) for t, _ in ent.additive_traits)
            ml.append(f"  type trait = {tr_cases}")
            tr_arms = " | ".join(f'{ml_ctor(t)} -> "{t}"' for t, _ in ent.additive_traits)
            ml.append(f"  let trait_to_string = function {tr_arms}")

        ml.append("  type t = {")
        ml.extend(rec_fields)
        ml.append("  }")
        ml.append("end")
        ml.append("")

    mli_path.write_text("\n".join(mli) + "\n")
    ml_path.write_text("\n".join(ml) + "\n")
    return mli_path, ml_path

# ---------------------------------------------------------------------------
# Data (.ud) -> OCaml (.ml + .mli) Lowering
# ---------------------------------------------------------------------------

def line_dir(file: str, line: int) -> str:
    return f'# {line} "{file}"'

def parse_card_literal(raw: str, file: str, line: int) -> str:
    m = re.fullmatch(r"\{\s*(\d+)\s*,\s*(\d+|N|\*)\s*\}", raw.strip())
    if not m:
        raise ValueError(f"{file}:{line}: invalid cardinality literal '{raw}' (expected {{min,max}})")
    mn = int(m.group(1))
    mx = "None" if m.group(2) in ("N", "*") else f"Some {int(m.group(2))}"
    return f"{{ min = {mn}; max = {mx} }}"

def unquote_udon_str(raw: str) -> str:
    s = raw.strip()
    if len(s) >= 2 and s[0] == '"' and s[-1] == '"':
        # Handle basic escapes
        inner = s[1:-1]
        return bytes(inner, "utf-8").decode("unicode_escape")
    return s

def resolve_ref_expr(
    raw: str,
    tref: TypeRef,
    schema: ContextSchema,
    all_schemas: dict[str, ContextSchema],
    ctx_mod: str,
    imported_stores: dict[str, str],
    local_id_map: dict[str, tuple[str, Optional[str]]],
    file: str,
    line: int,
) -> str:
    """Lower `@[slug]` or `@store:slug` into an OCaml identifier expression."""
    s = raw.strip()
    if s.startswith("@[") and s.endswith("]"):
        body = s[2:-1].strip()
    elif s.startswith("@{") and s.endswith("}"):
        body = s[2:-1].strip()
    elif s.startswith("@"):
        body = s[1:].strip()
    else:
        body = s

    # Cross-context qualified ref: @store_mod:slug
    if ":" in body:
        store_alias, slug = body.split(":", 1)
        store_mod = ml_ctor(imported_stores.get(store_alias, store_alias))
        target_ent = tref.base
        ident = f"{store_mod}.{ml_ident(target_ent)}_{ml_ident(slug)}"
        if tref.ref_context:
            target_schema = all_schemas[tref.ref_context]
            ent = target_schema.entities[tref.base]
            if ent.trait_axis and not tref.ref_trait:
                return f"({ident} :> {ml_ctor(tref.ref_context)}.{ml_ctor(tref.base)}.any_id)"
        return ident

    # Local reference: look up which entity declared `body` (so passing a wrong entity kind
    # emits the ACTUAL OCaml variable of that wrong entity, letting `ocamlc` catch the type mismatch!)
    if body in local_id_map:
        actual_ent, _actual_trait = local_id_map[body]
        ident = f"{ml_ident(actual_ent)}_{ml_ident(body)}"
    else:
        # Unbound! Emit expected-entity-prefixed identifier so ocamlc reports `Unbound value <ent>_<slug>`
        ident = f"{ml_ident(tref.base)}_{ml_ident(body)}"

    # If the schema expects an unconstrained `any_id` on an entity with a trait axis,
    # upcast ONLY when the local binding is actually that entity (so wrong-entity refs
    # still fail cleanly as `Outline.id` vs `Piece.any_id` in ocamlc!).
    if not tref.ref_context:
        expected_ent = schema.entities[tref.base]
        if expected_ent.trait_axis and not tref.ref_trait:
            if body in local_id_map and local_id_map[body][0] == tref.base:
                return f"({ident} :> {ctx_mod}.{ml_ctor(tref.base)}.any_id)"
    return ident

def lower_scalar(
    av: AttrVal,
    tref: TypeRef,
    schema: ContextSchema,
    all_schemas: dict[str, ContextSchema],
    ctx_mod: str,
    imported_stores: dict[str, str],
    local_id_map: dict[str, tuple[str, Optional[str]]],
    file: str,
) -> str:
    if tref.is_entity_ref:
        return resolve_ref_expr(
            av.raw, tref, schema, all_schemas, ctx_mod, imported_stores, local_id_map, file, av.line
        )
    if tref.base == "string":
        return ml_string(unquote_udon_str(av.raw))
    if tref.base == "int":
        return av.raw.strip()
    if tref.base == "bool":
        v = av.raw.strip().lower()
        return "true" if v in ("true", "yes", "1") else ("false" if v in ("false", "no", "0") else av.raw.strip())
    if tref.base == "card":
        return parse_card_literal(av.raw, file, av.line)
    if tref.base in schema.enums:
        return f"{ctx_mod}.{ml_ctor(av.raw.strip())}"
    if tref.base in schema.variants:
        if av.elem_children:
            return lower_variant_elem(
                av.elem_children[0], schema.variants[tref.base], schema, all_schemas,
                ctx_mod, imported_stores, local_id_map
            )
        raise ValueError(f"{file}:{av.line}: expected indented variant element for '{tref.base}'")
    if tref.base in schema.records:
        if av.elem_children:
            return lower_record_elem(
                av.elem_children[0], schema.records[tref.base], schema, all_schemas,
                ctx_mod, imported_stores, local_id_map
            )
        raise ValueError(f"{file}:{av.line}: expected indented record element for '{tref.base}'")
    return av.raw.strip()

def lower_field_value(
    fspec: FieldSpec,
    elem: UdonElement,
    schema: ContextSchema,
    all_schemas: dict[str, ContextSchema],
    ctx_mod: str,
    imported_stores: dict[str, str],
    local_id_map: dict[str, tuple[str, Optional[str]]],
) -> Optional[str]:
    """Lower a declared schema field from an UDON element. Returns None if required field is missing (so ocamlc catches it!)."""
    # Special UDON $main mapping
    if fspec.name == "main":
        if elem.main is not None:
            val_expr = ml_string(elem.main)
            return f"Some {val_expr}" if fspec.tref.modifier == "?" else val_expr
        if "main" in elem.attrs:
            av = elem.attrs["main"][-1]
            val_expr = ml_string(unquote_udon_str(av.raw))
            return f"Some {val_expr}" if fspec.tref.modifier == "?" else val_expr
        if fspec.tref.modifier == "?":
            return "None"
        return None  # Let ocamlc report missing required field `main`!

    vals = elem.attrs.get(fspec.name, [])

    # Check if this field is a list of records/variants populated by indented child elements
    if fspec.tref.modifier in ("*", "+") and not vals:
        if fspec.tref.base in schema.records:
            rec = schema.records[fspec.tref.base]
            matching = [c for c in elem.children if isinstance(c, UdonElement) and c.name == rec.name]
            items = [
                lower_record_elem(c, rec, schema, all_schemas, ctx_mod, imported_stores, local_id_map)
                for c in matching
            ]
            if fspec.tref.modifier == "*":
                return "[" + "; ".join(items) + "]"
            elif items:
                return f"{ctx_mod}.Nonempty ({items[0]}, [" + "; ".join(items[1:]) + "])"
            return None
        if fspec.tref.base in schema.variants:
            var = schema.variants[fspec.tref.base]
            case_names = {vc.name for vc in var.cases}
            matching = [c for c in elem.children if isinstance(c, UdonElement) and c.name in case_names]
            items = [
                lower_variant_elem(c, var, schema, all_schemas, ctx_mod, imported_stores, local_id_map)
                for c in matching
            ]
            if fspec.tref.modifier == "*":
                return "[" + "; ".join(items) + "]"
            elif items:
                return f"{ctx_mod}.Nonempty ({items[0]}, [" + "; ".join(items[1:]) + "])"
            return None

    # Check if a single variant field was supplied directly as a child element
    if fspec.tref.modifier in ("", "?") and not vals and fspec.tref.base in schema.variants:
        var = schema.variants[fspec.tref.base]
        case_names = {vc.name for vc in var.cases}
        matching = [c for c in elem.children if isinstance(c, UdonElement) and c.name in case_names]
        if matching:
            expr = lower_variant_elem(matching[0], var, schema, all_schemas, ctx_mod, imported_stores, local_id_map)
            return f"Some ({expr})" if fspec.tref.modifier == "?" else expr

    if fspec.tref.modifier == "?":
        if not vals:
            return "None"
        inner = lower_scalar(vals[-1], fspec.tref, schema, all_schemas, ctx_mod, imported_stores, local_id_map, elem.file)
        return f"Some ({inner})"

    if fspec.tref.modifier in ("*", "+"):
        # Supports BOTH `[a b c]` list literals AND repeated `:attr v1` / `:attr v2` lines!
        items: list[str] = []
        for av in vals:
            if av.raw.strip().startswith("["):
                for tok in parse_list_tokens(av.raw):
                    items.append(
                        lower_scalar(
                            AttrVal(tok, av.line), fspec.tref, schema, all_schemas,
                            ctx_mod, imported_stores, local_id_map, elem.file
                        )
                    )
            else:
                items.append(
                    lower_scalar(
                        av, fspec.tref, schema, all_schemas,
                        ctx_mod, imported_stores, local_id_map, elem.file
                    )
                )
        if fspec.tref.modifier == "*":
            return "[" + "; ".join(items) + "]"
        # Non-empty list!
        if not items:
            return None  # Let ocamlc report missing required nonempty field!
        return f"{ctx_mod}.Nonempty ({items[0]}, [" + "; ".join(items[1:]) + "])"

    # Required single value
    if not vals:
        return None  # Let ocamlc report missing required field!
    if len(vals) > 1:
        raise ValueError(
            f"{elem.file}:{vals[1].line}: attribute ':{fspec.name}' repeated on single-valued field"
        )
    return lower_scalar(vals[0], fspec.tref, schema, all_schemas, ctx_mod, imported_stores, local_id_map, elem.file)

def lower_fields_block(
    fields: list[FieldSpec],
    elem: UdonElement,
    schema: ContextSchema,
    all_schemas: dict[str, ContextSchema],
    ctx_mod: str,
    imported_stores: dict[str, str],
    local_id_map: dict[str, tuple[str, Optional[str]]],
    extra_bindings: list[str],
) -> str:
    declared_names = {f.name for f in fields}
    parts: list[str] = list(extra_bindings)

    for f in fields:
        expr = lower_field_value(f, elem, schema, all_schemas, ctx_mod, imported_stores, local_id_map)
        if expr is not None:
            # Emit line directive for the attribute if present
            fline = elem.attrs[f.name][0].line if f.name in elem.attrs else elem.line
            parts.append(f"\n{line_dir(elem.file, fline)}\n    {ml_ident(f.name)} = {expr}")

    # Pass through any UNDECLARED attributes directly into the OCaml record literal
    # so `ocamlc` itself catches typos with `Error: Unbound record field ...` at the exact .ud line!
    for aname, avals in elem.attrs.items():
        if aname not in declared_names:
            av = avals[0]
            parts.append(f"\n{line_dir(elem.file, av.line)}\n    {ml_ident(aname)} = {ml_string(av.raw)}")

    return "{\n" + ";\n".join(parts) + "\n  }"

def lower_record_elem(
    elem: UdonElement,
    rec: RecordSpec,
    schema: ContextSchema,
    all_schemas: dict[str, ContextSchema],
    ctx_mod: str,
    imported_stores: dict[str, str],
    local_id_map: dict[str, tuple[str, Optional[str]]],
) -> str:
    body = lower_fields_block(
        rec.fields, elem, schema, all_schemas, ctx_mod, imported_stores, local_id_map, []
    )
    return f"({body} : {ctx_mod}.{ml_ident(rec.name)})"

def lower_variant_elem(
    elem: UdonElement,
    var: VariantSpec,
    schema: ContextSchema,
    all_schemas: dict[str, ContextSchema],
    ctx_mod: str,
    imported_stores: dict[str, str],
    local_id_map: dict[str, tuple[str, Optional[str]]],
) -> str:
    if elem.name is None:
        raise ValueError(
            f"{elem.file}:{elem.line}: anonymous UDON element cannot lower to OCaml variant '{var.name}'"
        )
    case_map = {vc.name: vc for vc in var.cases}
    if elem.name not in case_map:
        # Emit the unknown constructor directly so ocamlc reports `Unbound constructor` at .ud line!
        return f"\n{line_dir(elem.file, elem.line)}\n  {ctx_mod}.{ml_ctor(elem.name)}"
    vc = case_map[elem.name]
    if not vc.fields:
        return f"{ctx_mod}.{ml_ctor(vc.name)}"
    body = lower_fields_block(
        vc.fields, elem, schema, all_schemas, ctx_mod, imported_stores, local_id_map, []
    )
    return f"({ctx_mod}.{ml_ctor(vc.name)} {body})"

def compile_data_file(
    data_path: Path,
    all_schemas: dict[str, ContextSchema],
    out_dir: Path,
    module_name: Optional[str] = None,
) -> tuple[Path, Path]:
    roots = parse_udon(data_path.read_text(), str(data_path))
    doc_elems = [r for r in roots if isinstance(r, UdonElement) and r.name == "document"]
    if len(doc_elems) != 1:
        raise ValueError(f"{data_path}: expected one top-level |document[name] :context <ctx>")
    doc = doc_elems[0]
    ctx_name = doc.attrs["context"][-1].raw.strip()
    schema = all_schemas[ctx_name]
    ctx_mod = ml_ctor(schema.name)

    imported_stores: dict[str, str] = {}
    if "imports" in doc.attrs:
        for av in doc.attrs["imports"]:
            for tok in parse_list_tokens(av.raw):
                if "=" in tok:
                    alias, mod = tok.split("=", 1)
                    imported_stores[alias] = mod
                else:
                    imported_stores[tok] = tok

    mod_base = ml_ident(module_name or doc.key or data_path.stem)
    ml_path = out_dir / f"{mod_base}.ml"
    mli_path = out_dir / f"{mod_base}.mli"

    # Categorize top-level children of |document
    entity_elems: list[tuple[EntitySpec, UdonElement]] = []
    variant_elems: list[tuple[VariantSpec, UdonElement]] = []
    # Map variant case name -> VariantSpec
    vcase_to_var: dict[str, VariantSpec] = {}
    for var in schema.variants.values():
        for vc in var.cases:
            vcase_to_var[vc.name] = var

    for ch in doc.children:
        if not isinstance(ch, UdonElement):
            continue
        if ch.name is None:
            raise ValueError(
                f"{ch.file}:{ch.line}: anonymous element `|` has no constructor name in Bounded Context '{schema.name}'"
            )
        if ch.name in schema.entities:
            entity_elems.append((schema.entities[ch.name], ch))
        elif ch.name in vcase_to_var:
            variant_elems.append((vcase_to_var[ch.name], ch))
        else:
            raise ValueError(
                f"{ch.file}:{ch.line}: element '|{ch.name}' is not in the Ubiquitous Language of '{schema.name}'"
            )

    # Pass 1: Validate unique keys & trait axes; mint typed Entity ID witnesses
    local_id_map: dict[str, tuple[str, Optional[str]]] = {}  # slug -> (entity_name, axis_trait)
    seen_key_lines: dict[str, tuple[str, int]] = {}

    ml: list[str] = [
        f"(* Generated from {data_path} against schema {schema.name} *)",
        f"open {ctx_mod}",
        "",
        "(* --- Pass 1: Entity Identity Witnesses (enables forward references!) --- *)",
    ]
    mli: list[str] = [
        f"(* Generated interface for {data_path} (Bounded Context: {schema.name}) *)",
        "",
    ]

    for ent, elem in entity_elems:
        if not elem.key:
            raise ValueError(f"{elem.file}:{elem.line}: entity '|{ent.name}' requires a [key] identity")
        if elem.key in seen_key_lines:
            prev_ent, prev_line = seen_key_lines[elem.key]
            raise ValueError(
                f"{elem.file}:{elem.line}: duplicate key '[{elem.key}]' "
                f"(already declared by '|{prev_ent}' at line {prev_line}; OCaml `let` would silently shadow!)"
            )
        seen_key_lines[elem.key] = (ent.name, elem.line)

        axis_val: Optional[str] = None
        if ent.trait_axis:
            axis_allowed = {v for v, _ in ent.trait_axis.values}
            found_axis = [t for t in elem.traits if t in axis_allowed]
            if len(found_axis) == 0:
                raise ValueError(
                    f"{elem.file}:{elem.line}: entity '|{ent.name}[{elem.key}]' missing required "
                    f"trait-axis '{ent.trait_axis.name}' (one of: {', '.join('.' + v for v, _ in ent.trait_axis.values)})"
                )
            if len(found_axis) > 1:
                raise ValueError(
                    f"{elem.file}:{elem.line}: entity '|{ent.name}[{elem.key}]' has conflicting traits "
                    f"{', '.join('.' + t for t in found_axis)} on disjoint trait-axis '{ent.trait_axis.name}'"
                )
            axis_val = found_axis[0]

        # Validate unknown traits
        known_traits = set()
        if ent.trait_axis:
            known_traits.update(v for v, _ in ent.trait_axis.values)
        known_traits.update(t for t, _ in ent.additive_traits)
        unknown_t = [t for t in elem.traits if t not in known_traits]
        if unknown_t:
            raise ValueError(
                f"{elem.file}:{elem.line}: unknown trait(s) {', '.join('.' + t for t in unknown_t)} on '|{ent.name}[{elem.key}]'"
            )

        local_id_map[elem.key] = (ent.name, axis_val)
        var_name = f"{ml_ident(ent.name)}_{ml_ident(elem.key)}"
        emod = ml_ctor(ent.name)
        ml.append(line_dir(elem.file, elem.line))
        if ent.trait_axis and axis_val:
            ml.append(f'let {var_name} : [ `{ml_ctor(axis_val)} ] {ctx_mod}.{emod}.id = {ctx_mod}.{emod}.mint_{ml_ident(axis_val)} "{elem.key}"')
            mli.append(f'val {var_name} : [ `{ml_ctor(axis_val)} ] {ctx_mod}.{emod}.id')
        else:
            ml.append(f'let {var_name} : {ctx_mod}.{emod}.id = {ctx_mod}.{emod}.mint "{elem.key}"')
            mli.append(f'val {var_name} : {ctx_mod}.{emod}.id')

    ml.append("")
    ml.append("(* --- Pass 2: Entity Values (with exact .ud line directives) --- *)")
    mli.append("")

    # Group entities by kind for exported lists
    entities_by_kind: dict[str, list[str]] = {ename: [] for ename in schema.entities}

    for ent, elem in entity_elems:
        assert elem.key
        emod = ml_ctor(ent.name)
        id_var = f"{ml_ident(ent.name)}_{ml_ident(elem.key)}"
        val_var = f"val_{id_var}"
        entities_by_kind[ent.name].append(val_var)

        extra_bindings: list[str] = []
        if ent.trait_axis:
            axis_val = local_id_map[elem.key][1]
            assert axis_val
            extra_bindings.append(f"    id = ({id_var} :> {ctx_mod}.{emod}.any_id)")
            extra_bindings.append(f"    {ml_ident(ent.trait_axis.name)} = {ctx_mod}.{emod}.{ml_ctor(axis_val)}")
        else:
            extra_bindings.append(f"    id = {id_var}")

        if ent.additive_traits:
            add_allowed = {t for t, _ in ent.additive_traits}
            present = [f"{ctx_mod}.{emod}.{ml_ctor(t)}" for t in elem.traits if t in add_allowed]
            extra_bindings.append(f"    traits = [" + "; ".join(present) + "]")

        # Partitioned child slots
        for slot_elem, slot_ty in ent.child_slots:
            matching = [c for c in elem.children if isinstance(c, UdonElement) and c.name == slot_elem]
            items: list[str] = []
            for mc in matching:
                if slot_ty in schema.records:
                    items.append(
                        lower_record_elem(mc, schema.records[slot_ty], schema, all_schemas, ctx_mod, imported_stores, local_id_map)
                    )
                elif slot_ty in schema.variants:
                    items.append(
                        lower_variant_elem(mc, schema.variants[slot_ty], schema, all_schemas, ctx_mod, imported_stores, local_id_map)
                    )
            extra_bindings.append(f"    {ml_ident(slot_elem)}_items = [\n      " + ";\n      ".join(items) + "\n    ]")

        # Ordered variant children
        if ent.ordered_children_type:
            var = schema.variants[ent.ordered_children_type]
            items = []
            for c in elem.children:
                if isinstance(c, UdonElement):
                    items.append(
                        lower_variant_elem(c, var, schema, all_schemas, ctx_mod, imported_stores, local_id_map)
                    )
            extra_bindings.append(f"    children = [\n      " + ";\n      ".join(items) + "\n    ]")

        # Prose lines + compile-time checked @{ref} extraction!
        if ent.prose_ref_entity:
            prose_lines: list[str] = []
            prose_ref_exprs: list[str] = []
            ref_tref = TypeRef(base=ent.prose_ref_entity, is_entity_ref=True)
            for c in elem.children:
                if isinstance(c, UdonText):
                    prose_lines.append(ml_string(c.text))
                    for slug, rline in c.inline_refs:
                        rexpr = resolve_ref_expr(
                            f"@[{slug}]", ref_tref, schema, all_schemas, ctx_mod,
                            imported_stores, local_id_map, elem.file, rline
                        )
                        prose_ref_exprs.append(f"\n{line_dir(elem.file, rline)}\n      {rexpr}")
            # Also scan $main for inline @{ref} mentions!
            if elem.main:
                for slug, rline in extract_inline_refs(elem.main, elem.line):
                    rexpr = resolve_ref_expr(
                        f"@[{slug}]", ref_tref, schema, all_schemas, ctx_mod,
                        imported_stores, local_id_map, elem.file, rline
                    )
                    prose_ref_exprs.append(f"\n{line_dir(elem.file, rline)}\n      {rexpr}")
            extra_bindings.append(f"    prose = [" + "; ".join(prose_lines) + "]")
            extra_bindings.append(f"    prose_refs = [" + "; ".join(prose_ref_exprs) + "]")

        rec_literal = lower_fields_block(
            ent.fields, elem, schema, all_schemas, ctx_mod, imported_stores, local_id_map, extra_bindings
        )
        ml.append(line_dir(elem.file, elem.line))
        ml.append(f"let {val_var} : {ctx_mod}.{emod}.t = {rec_literal}")
        ml.append("")

    # Export entity lists
    for ename, val_vars in entities_by_kind.items():
        emod = ml_ctor(ename)
        list_name = f"all_{ml_ident(ename)}s"
        ml.append(f"let {list_name} : {ctx_mod}.{emod}.t list = [" + "; ".join(val_vars) + "]")
        mli.append(f"val {list_name} : {ctx_mod}.{emod}.t list")

    # Emit top-level variant collections (e.g., `|made`, `|checked`, `|decided`, `|ast-root`)
    variants_by_type: dict[str, list[str]] = {vname: [] for vname in schema.variants}
    for var, elem in variant_elems:
        expr = lower_variant_elem(elem, var, schema, all_schemas, ctx_mod, imported_stores, local_id_map)
        variants_by_type[var.name].append(f"\n{line_dir(elem.file, elem.line)}\n  {expr}")

    for vname, exprs in variants_by_type.items():
        if exprs:
            list_name = f"all_{ml_ident(vname)}s"
            ml.append(f"let {list_name} : {ctx_mod}.{ml_ident(vname)} list = [" + ";\n".join(exprs) + "\n]")
            mli.append(f"val {list_name} : {ctx_mod}.{ml_ident(vname)} list")

    ml_path.write_text("\n".join(ml) + "\n")
    mli_path.write_text("\n".join(mli) + "\n")
    return mli_path, ml_path

# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main(argv: list[str]) -> int:
    if len(argv) < 4:
        print("Usage:")
        print("  udon2ml.py schema <out_dir> <schema1.ud> [<schema2.ud> ...]")
        print("  udon2ml.py data   <out_dir> <data.ud> --schemas <s1.ud> [<s2.ud> ...] [--mod <name>]")
        return 2

    cmd = argv[1]
    out_dir = Path(argv[2])
    out_dir.mkdir(parents=True, exist_ok=True)

    if cmd == "schema":
        schema_paths = [Path(p) for p in argv[3:]]
        schemas: dict[str, ContextSchema] = {}
        for sp in schema_paths:
            sc = load_schema(sp)
            schemas[sc.name] = sc
        for sc in schemas.values():
            mli, ml = emit_schema_ocaml(sc, schemas, out_dir)
            print(f"generated {mli.name}, {ml.name}")
        return 0

    if cmd == "data":
        data_path = Path(argv[3])
        rest = argv[4:]
        schema_paths = []
        mod_name = None
        i = 0
        while i < len(rest):
            if rest[i] == "--schemas":
                i += 1
                while i < len(rest) and not rest[i].startswith("--"):
                    schema_paths.append(Path(rest[i]))
                    i += 1
            elif rest[i] == "--mod":
                mod_name = rest[i + 1]
                i += 2
            else:
                i += 1
        schemas = {}
        for sp in schema_paths:
            sc = load_schema(sp)
            schemas[sc.name] = sc
        mli, ml = compile_data_file(data_path, schemas, out_dir, module_name=mod_name)
        print(f"generated {mli.name}, {ml.name}")
        return 0

    print(f"Unknown command: {cmd}")
    return 2

if __name__ == "__main__":
    sys.exit(main(sys.argv))
