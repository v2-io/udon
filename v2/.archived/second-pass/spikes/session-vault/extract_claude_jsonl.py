#!/usr/bin/env python3
"""Extract Claude Code session JSONL files into readable markdown vault files.

Keeps conversation life: full user/assistant text, tool_use as one-line stubs.
Does not summarize. Does not delete source sessions.

Default source (udon project):
  ~/.claude/projects/-Users-josephwecker-v2-src-udon/*.jsonl

Default output:
  <repo>/v2-spec/spikes/session-vault/raw/claude/<id8>-<slug>.md
  + INVENTORY.md in the same directory.

Usage:
  python3 extract_claude_jsonl.py
  python3 extract_claude_jsonl.py --source DIR --out DIR
  python3 extract_claude_jsonl.py --force   # rewrite even if target newer
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path


DEFAULT_SOURCE = Path.home() / ".claude/projects/-Users-josephwecker-v2-src-udon"
REPO_ROOT = Path(__file__).resolve().parents[3]  # .../udon
DEFAULT_OUT = REPO_ROOT / "v2-spec/spikes/session-vault/raw/claude"

USER_QUERY_RE = re.compile(r"<user_query>\s*(.*?)\s*</user_query>", re.DOTALL | re.IGNORECASE)
COMMAND_ARGS_RE = re.compile(
    r"<command-args>\s*(.*?)\s*</command-args>", re.DOTALL | re.IGNORECASE
)
COMMAND_NAME_RE = re.compile(
    r"<command-name>\s*(.*?)\s*</command-name>", re.DOTALL | re.IGNORECASE
)
SLUG_STRIP_RE = re.compile(r"[^a-z0-9]+")
# Tags whose *presence alone* is harness noise. command-args is special: its
# body may hold real user intent (e.g. /claude-api with a parenthetical brief).
META_STRIP_TAGS = (
    "local-command-caveat",
    "local-command-stdout",
    "local-command-stderr",
    "command-name",
    "command-message",
    "task-notification",
    "system-reminder",
    "task-id",
    "tool-use-id",
    "output-file",
    "status",
    "summary",
)


@dataclass
class SessionStats:
    session_id: str
    source: Path
    mtime: float
    jsonl_size: int
    title: str | None = None
    out_path: Path | None = None
    out_size: int = 0
    user_turns: int = 0
    assistant_turns: int = 0
    tool_stubs: int = 0
    first_user_preview: str = ""
    skipped: bool = False
    parse_errors: int = 0
    notes: list[str] = field(default_factory=list)


def slugify(text: str, max_len: int = 48) -> str:
    s = text.strip().lower()
    s = SLUG_STRIP_RE.sub("-", s).strip("-")
    if not s:
        return "session"
    if len(s) > max_len:
        s = s[:max_len].rstrip("-")
        # avoid cutting mid-token when possible
        if "-" in s:
            s = s.rsplit("-", 1)[0]
    return s or "session"


def human_size(n: int) -> str:
    if n < 1024:
        return f"{n} B"
    if n < 1024 * 1024:
        return f"{n / 1024:.1f} KB"
    return f"{n / (1024 * 1024):.2f} MB"


def mtime_iso(path: Path) -> str:
    ts = path.stat().st_mtime
    return datetime.fromtimestamp(ts, tz=timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC")


def extract_user_query(text: str) -> str:
    """Prefer <user_query> body when present; else normalize harness wrappers."""
    m = USER_QUERY_RE.search(text)
    if m:
        return m.group(1).strip()
    return normalize_harness_user_text(text)


def normalize_harness_user_text(text: str) -> str:
    """Turn command/task XML wrappers into readable user text when possible.

    - Pure /model, /copy, local-command-stdout, task-notification → empty (skip)
    - /some-cmd with non-empty command-args → keep args (and optional cmd name)
    - Ordinary prose → unchanged
    """
    t = text.strip()
    if not t:
        return ""

    has_command_xml = bool(COMMAND_NAME_RE.search(t) or COMMAND_ARGS_RE.search(t))
    has_task = "<task-notification" in t.lower()
    has_local_stdout = "<local-command-stdout" in t.lower()
    has_caveat = "<local-command-caveat" in t.lower()
    has_reminder = "<system-reminder" in t.lower()

    if has_command_xml:
        args_m = COMMAND_ARGS_RE.search(t)
        name_m = COMMAND_NAME_RE.search(t)
        args = (args_m.group(1).strip() if args_m else "")
        name = (name_m.group(1).strip() if name_m else "")
        # Strip the harness tags; if leftover prose exists, keep it too.
        remainder = t
        for tag in ("command-name", "command-message", "command-args"):
            remainder = re.sub(
                rf"<{tag}\b[^>]*>.*?</{tag}>",
                "",
                remainder,
                flags=re.DOTALL | re.IGNORECASE,
            )
        remainder = re.sub(r"\s+", " ", remainder).strip()
        if args:
            if name:
                return f"{name}: {args}" if not remainder else f"{name}: {args}\n\n{remainder}"
            return args if not remainder else f"{args}\n\n{remainder}"
        # Empty args — pure slash-command invocation (e.g. /model, /copy)
        if remainder:
            return remainder
        return ""  # pure meta command

    if has_task or has_local_stdout or has_caveat or has_reminder:
        # Drop known meta blocks; keep any residual human prose.
        stripped = t
        for tag in META_STRIP_TAGS:
            stripped = re.sub(
                rf"<{tag}\b[^>]*>.*?</{tag}>",
                "",
                stripped,
                flags=re.DOTALL | re.IGNORECASE,
            )
            stripped = re.sub(rf"<{tag}\b[^>]*/?>", "", stripped, flags=re.IGNORECASE)
        stripped = re.sub(r"<[^>]+>", " ", stripped)
        stripped = re.sub(r"\s+", " ", stripped).strip()
        if not stripped:
            return ""
        if stripped.lower().startswith("caveat: the messages below were generated"):
            return ""
        return stripped

    return t


def text_is_pure_meta(text: str) -> bool:
    """True if the message is only system/command/task scaffolding with no real user prose."""
    t = text.strip()
    if not t:
        return True
    if t.lower().startswith("caveat: the messages below were generated"):
        return True
    # Skill-injection dumps often start with this harness line and are huge.
    if t.startswith("Base directory for this skill:"):
        return True
    return False


def collect_user_text(content) -> str | None:
    """Return user-facing text, or None if this record should be skipped."""
    if content is None:
        return None
    if isinstance(content, str):
        text = extract_user_query(content)
        if text_is_pure_meta(text):
            return None
        return text
    if isinstance(content, list):
        texts: list[str] = []
        for block in content:
            if not isinstance(block, dict):
                continue
            btype = block.get("type")
            if btype == "text":
                t = block.get("text") or ""
                if t.strip():
                    texts.append(t)
            elif btype == "image":
                texts.append("[image]")
            elif btype == "tool_result":
                # tool results are noise for vault prose; skip
                continue
            else:
                # unknown block — keep a stub so we don't lose signal silently
                texts.append(f"[{btype or 'block'}]")
        if not texts:
            return None  # pure tool_result or empty
        joined = "\n".join(texts)
        joined = extract_user_query(joined)
        if text_is_pure_meta(joined):
            return None
        return joined
    return str(content)


def collect_assistant_parts(content) -> list[tuple[str, str]]:
    """Return list of (kind, payload) where kind is 'text' or 'tool_use'.

    thinking blocks are omitted (keep file readable; prose is in text).
    """
    parts: list[tuple[str, str]] = []
    if content is None:
        return parts
    if isinstance(content, str):
        if content.strip():
            parts.append(("text", content))
        return parts
    if isinstance(content, list):
        for block in content:
            if not isinstance(block, dict):
                continue
            btype = block.get("type")
            if btype == "text":
                t = block.get("text") or ""
                if t.strip():
                    parts.append(("text", t))
            elif btype == "tool_use":
                name = block.get("name") or "unknown"
                parts.append(("tool_use", name))
            # skip thinking, redacted_thinking, etc.
        return parts
    s = str(content)
    if s.strip():
        parts.append(("text", s))
    return parts


def first_title_from_jsonl(path: Path) -> str | None:
    """Scan for ai-title records (and stop early once found if possible)."""
    title = None
    try:
        with open(path, encoding="utf-8", errors="replace") as fh:
            for line in fh:
                if '"ai-title"' not in line and '"aiTitle"' not in line:
                    continue
                try:
                    o = json.loads(line)
                except json.JSONDecodeError:
                    continue
                if o.get("type") == "ai-title" and o.get("aiTitle"):
                    title = o["aiTitle"]
                    # keep last non-empty title (titles can refine over session)
    except OSError:
        return None
    return title


def extract_session(src: Path, out_dir: Path, force: bool = False) -> SessionStats:
    session_id = src.stem
    id8 = session_id[:8]
    st = src.stat()
    stats = SessionStats(
        session_id=session_id,
        source=src,
        mtime=st.st_mtime,
        jsonl_size=st.st_size,
    )

    # Title pass (needed for slug / early skip)
    title = first_title_from_jsonl(src)
    stats.title = title

    # Early skip when we already have a titled extract newer than source.
    # (Untitled sessions need first-user text for the slug, so they always stream.)
    if title and not force:
        provisional = out_dir / f"{id8}-{slugify(title)}.md"
        if provisional.exists() and provisional.stat().st_mtime >= st.st_mtime:
            # Still need turn counts + first-user for inventory — stream without write.
            pass  # fall through; write gated later
        # Note: full skip-without-parse would leave inventory sparse; always stream.

    lines_out: list[str] = []
    first_user: str | None = None

    with open(src, encoding="utf-8", errors="replace") as fh:
        for raw in fh:
            raw = raw.strip()
            if not raw:
                continue
            try:
                rec = json.loads(raw)
            except json.JSONDecodeError:
                stats.parse_errors += 1
                continue

            rtype = rec.get("type")

            if rtype == "ai-title" and rec.get("aiTitle"):
                stats.title = rec["aiTitle"]
                continue

            if rtype == "user":
                if rec.get("isSidechain"):
                    continue
                # isMeta: skill dumps, caveats, harness injections — not human turns
                if rec.get("isMeta"):
                    continue
                content = (rec.get("message") or {}).get("content")
                text = collect_user_text(content)
                if text is None:
                    continue
                lines_out.append("## User\n\n")
                lines_out.append(text.rstrip() + "\n\n")
                stats.user_turns += 1
                if first_user is None:
                    first_user = text.strip()
                continue

            if rtype == "assistant":
                if rec.get("isSidechain"):
                    continue
                if rec.get("isMeta"):
                    continue
                content = (rec.get("message") or {}).get("content")
                parts = collect_assistant_parts(content)
                if not parts:
                    continue
                # Emit each part as its own ## Assistant section (matches hand-extract style
                # for tool stubs; consecutive text parts from one record merge).
                text_buf: list[str] = []
                tool_names: list[str] = []

                def flush_text():
                    nonlocal text_buf
                    if not text_buf:
                        return
                    body = "\n".join(text_buf).rstrip()
                    text_buf = []
                    if not body:
                        return
                    lines_out.append("## Assistant\n\n")
                    lines_out.append(body + "\n\n")
                    stats.assistant_turns += 1

                def flush_tools():
                    nonlocal tool_names
                    for name in tool_names:
                        lines_out.append("## Assistant\n\n")
                        lines_out.append(f"[tool_use name={name}]\n\n")
                        stats.tool_stubs += 1
                        stats.assistant_turns += 1
                    tool_names = []

                for kind, payload in parts:
                    if kind == "text":
                        if tool_names:
                            flush_tools()
                        text_buf.append(payload)
                    else:
                        if text_buf:
                            flush_text()
                        tool_names.append(payload)
                flush_text()
                flush_tools()
                continue

            # Skip pure system/meta noise: mode, permission-mode, bridge-session,
            # attachment, system, last-prompt, progress, etc.
            continue

    if first_user:
        preview = first_user.replace("\n", " ").strip()
        stats.first_user_preview = preview[:80]
    else:
        stats.first_user_preview = ""

    slug_src = stats.title or (first_user[:80] if first_user else "session")
    # If first_user starts with command tags and we have no title, try to clean
    if not stats.title and first_user:
        cleaned = re.sub(r"<[^>]+>", " ", first_user)
        cleaned = re.sub(r"\s+", " ", cleaned).strip()
        if cleaned:
            slug_src = cleaned[:80]
    slug = slugify(slug_src)
    out_path = out_dir / f"{id8}-{slug}.md"
    stats.out_path = out_path

    # Optional skip if target newer than source
    if out_path.exists() and not force:
        if out_path.stat().st_mtime >= st.st_mtime:
            stats.skipped = True
            stats.out_size = out_path.stat().st_size
            stats.notes.append("skipped (target newer than source)")
            return stats

    # If an older differently-slugged extract for same id8 exists, leave it;
    # we only write our canonical name. (Cleanup is caller's choice.)

    header_lines = [
        f"# Claude session `{session_id}`\n\n",
        f"- **Full session id:** `{session_id}`\n",
        f"- **Source:** `{src}`\n",
    ]
    if stats.title:
        header_lines.append(f"- **Title:** {stats.title}\n")
    header_lines.extend(
        [
            f"- **Source size:** {human_size(stats.jsonl_size)} ({stats.jsonl_size} bytes)\n",
            f"- **Source mtime:** {mtime_iso(src)}\n",
            f"- **Extracted:** {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M:%S UTC')}\n",
            f"- **Turns (approx):** {stats.user_turns} user / {stats.assistant_turns} assistant"
            f" ({stats.tool_stubs} tool stubs)\n",
        ]
    )
    if stats.parse_errors:
        header_lines.append(f"- **Parse errors (skipped lines):** {stats.parse_errors}\n")
    header_lines.append("\n---\n\n")

    body = "".join(lines_out)
    if not body.strip():
        body = "_No user/assistant text content extracted from this session._\n"
        stats.notes.append("empty extract")

    out_dir.mkdir(parents=True, exist_ok=True)
    out_path.write_text("".join(header_lines) + body, encoding="utf-8")
    stats.out_size = out_path.stat().st_size
    return stats


def write_inventory(out_dir: Path, all_stats: list[SessionStats]) -> Path:
    inv = out_dir / "INVENTORY.md"
    lines = [
        "# Claude session vault inventory\n\n",
        f"Generated: {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M:%S UTC')}\n\n",
        f"Source: `{DEFAULT_SOURCE}`\n\n",
        f"Sessions: **{len(all_stats)}**\n\n",
        "| id8 | mtime (UTC) | jsonl | md | user | asst | first user_query (80) | file |\n",
        "|-----|-------------|-------|----|------|------|----------------------|------|\n",
    ]
    # newest first
    ordered = sorted(all_stats, key=lambda s: s.mtime, reverse=True)
    for s in ordered:
        id8 = s.session_id[:8]
        mtime = datetime.fromtimestamp(s.mtime, tz=timezone.utc).strftime("%Y-%m-%d %H:%M")
        preview = s.first_user_preview.replace("|", "\\|")
        out_name = s.out_path.name if s.out_path else ""
        lines.append(
            f"| `{id8}` | {mtime} | {human_size(s.jsonl_size)} | {human_size(s.out_size)}"
            f" | {s.user_turns} | {s.assistant_turns} | {preview} | `{out_name}` |\n"
        )

    lines.append("\n## Details\n\n")
    for s in ordered:
        lines.append(f"### `{s.session_id}`\n\n")
        if s.title:
            lines.append(f"- **Title:** {s.title}\n")
        lines.append(f"- **Source:** `{s.source}`\n")
        if s.out_path:
            lines.append(f"- **Output:** `{s.out_path}`\n")
        lines.append(f"- **JSONL size:** {s.jsonl_size} bytes\n")
        lines.append(f"- **MD size:** {s.out_size} bytes\n")
        lines.append(
            f"- **Turns:** {s.user_turns} user, {s.assistant_turns} assistant "
            f"({s.tool_stubs} tool stubs)\n"
        )
        if s.first_user_preview:
            lines.append(f"- **First user:** {s.first_user_preview}\n")
        if s.notes:
            lines.append(f"- **Notes:** {'; '.join(s.notes)}\n")
        if s.parse_errors:
            lines.append(f"- **Parse errors:** {s.parse_errors}\n")
        lines.append("\n")

    inv.write_text("".join(lines), encoding="utf-8")
    return inv


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--source",
        type=Path,
        default=DEFAULT_SOURCE,
        help=f"Directory of *.jsonl sessions (default: {DEFAULT_SOURCE})",
    )
    ap.add_argument(
        "--out",
        type=Path,
        default=DEFAULT_OUT,
        help=f"Output directory (default: {DEFAULT_OUT})",
    )
    ap.add_argument(
        "--force",
        action="store_true",
        help="Rewrite even if target markdown is newer than source jsonl",
    )
    args = ap.parse_args(argv)

    source: Path = args.source.expanduser()
    out_dir: Path = args.out.expanduser()

    if not source.is_dir():
        print(f"error: source directory not found: {source}", file=sys.stderr)
        return 1

    files = sorted(source.glob("*.jsonl"))
    if not files:
        print(f"error: no *.jsonl under {source}", file=sys.stderr)
        return 1

    out_dir.mkdir(parents=True, exist_ok=True)
    all_stats: list[SessionStats] = []
    for src in files:
        print(f"extracting {src.name} ({human_size(src.stat().st_size)}) …", flush=True)
        try:
            stats = extract_session(src, out_dir, force=args.force)
        except Exception as e:
            print(f"  FAILED: {e}", file=sys.stderr)
            stats = SessionStats(
                session_id=src.stem,
                source=src,
                mtime=src.stat().st_mtime,
                jsonl_size=src.stat().st_size,
                notes=[f"FAILED: {e}"],
            )
        all_stats.append(stats)
        status = "skipped" if stats.skipped else "wrote"
        out_name = stats.out_path.name if stats.out_path else "?"
        print(
            f"  {status} {out_name}  "
            f"user={stats.user_turns} asst={stats.assistant_turns} "
            f"md={human_size(stats.out_size)}"
        )

    inv = write_inventory(out_dir, all_stats)
    wrote = sum(1 for s in all_stats if not s.skipped and s.out_size)
    skipped = sum(1 for s in all_stats if s.skipped)
    print(f"\nDone: {wrote} written, {skipped} skipped, inventory → {inv}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
