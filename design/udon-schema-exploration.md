# UDON Schema: Puzzle Pieces

**Laying out the pieces before attempting synthesis.**

This document collects the various threads around UDON schema, Archema integration,
and the "single source of truth" vision. It's meant to be rearranged and refined,
not read as a conclusion.

---

## The Vision (Incompletely Articulated)

Something like: **UDON documents are the single source of truth from which
everything else flows.**

- Schema definitions are UDON documents
- Resource definitions are UDON documents
- Instance data is UDON documents
- Validation rules derive from schema
- SQL DDL derives from schema
- JSON Schema derives from schema
- Ruby classes derive from schema
- API definitions derive from schema
- Documentation is embedded in schema

Self-describing, self-validating, declarative.

---

## Puzzle Piece 1: Basic Schema (feedback.md)

The RelaxNG-compact-inspired approach using UDON's own syntax:

```udon
|schema[article]
  |article
    :author! string           ; required, type string
    :date? date               ; optional, type date
    :tags? [string]           ; optional, list of strings

    |heading!                 ; exactly one required
      _text+                  ; one or more text nodes

    |section*                 ; zero or more
      |p+                     ; one or more paragraphs
      |figure?                ; optional
        :src! uri
        :alt! string
        :caption? string
```

**What this provides:**
- Element presence and cardinality (?, !, *, +)
- Attribute presence and basic types
- Nested structure validation
- Schema IS a valid UDON document

**What's missing:**
- Composition constraints (oneOf, anyOf)
- Conditional requirements (if/then)
- Relationships (references between elements)
- Behavioral layer (actions, policies)
- Evolution metadata (was, since, deprecated)
- "Soft" region declaration

---

## Puzzle Piece 2: Type Definitions

Custom types with constraints:

```udon
|type[email]
  :base string
  :pattern "^[^@]+@[^@]+$"

|type[user-role]
  :enum [admin author reader]

|type[positive-number]
  :base number
  :min 0
  :exclusive-min true

|type[uuid]
  :base string
  :pattern "[0-9a-f]{8}-[0-9a-f]{4}-..."
  :format uuid                ; semantic hint
```

Types can be referenced in schemas via `@[type-id]` or similar.

---

## Puzzle Piece 3: Composition Constraints (JSON Schema Vocabulary)

The constraints Archema already implements:

```udon
|constraints
  ; Exactly one must be present (polymorphic FK pattern)
  |one-of
    |present :post-id
    |present :photo-id
    |present :video-id

  ; At least one must be present
  |any-of
    |present :email
    |present :phone

  ; Conditional requirement
  |when :payment-type :card
    |required :card-number

  ; Dependent requirement
  |dependent :email-verified
    :requires [email]
```

**Question:** Does this live inside the schema, or alongside it?

```udon
; Option A: Inline in element definition
|schema[comment]
  |comment
    :post-id? uuid
    :photo-id? uuid
    :video-id? uuid

    |constraints
      |one-of
        |present :post-id
        |present :photo-id
        |present :video-id

; Option B: Separate constraints block
|schema[comment]
  |comment
    :post-id? uuid
    :photo-id? uuid
    :video-id? uuid

|constraints[comment]
  |one-of
    |present :post-id
    |present :photo-id
    |present :video-id
```

---

## Puzzle Piece 4: Relationships

Not just "element X can contain element Y" but "element X references element Y
with semantics":

```udon
|relationships
  |belongs-to :author -> @[User]
    :source-attribute :author-id
    :optional

  |has-many :posts -> @[Post]
    :inverse :author

  |has-one :profile -> @[Profile]
    :required

  |many-to-many :tags -> @[Tag]
    :through @[PostTag]
```

**Questions:**
- Are relationships part of schema, or a separate concern?
- How do cross-file references resolve?
- Is `-> @[User]` the right syntax for type references?

---

## Puzzle Piece 5: Actions (Behavioral Layer)

This is where Archema goes beyond structural schema:

```udon
|actions
  |defaults [create read update destroy]

  |create[register]
    Register a new user with password verification.

    |argument :password
      :type string
      :sensitive
      :required

    |argument :password-confirmation
      :type string
      :sensitive

    |validate confirm(:password)
    |change :hash-password

  |read[active-users]
    |prepare :filter-active-only

  |update[publish]
    Publish a draft post.

    |validate :must-be-draft
    |change :set-published
```

**The Option C insight:** The implementation can be:
- Fully embedded (inline code block)
- Referenced (`:impl user_helpers#hash_password`)
- Declarative when possible (`:change set_attribute(:status :published)`)

```udon
|change :hash-password
  ; Option: inline implementation
  !:ruby
    def call(changeset)
      password = changeset.arguments[:password]
      changeset.put_change(:password_hash, BCrypt::Password.create(password))
    end

|change :set-published
  ; Option: declarative
  |set :status :published
  |set :published-at now()

|change :complex-logic
  ; Option: external reference
  :impl my_app/changes#complex_logic
```

---

## Puzzle Piece 6: Policies (Authorization)

```udon
|policies
  ; Admin bypass
  |bypass
    :when actor-attribute-equals(:role :admin)
    |authorize-if always

  ; Anyone can read
  |policy :action-type read
    |authorize-if always

  ; Only author can update
  |policy :action-type update
    |authorize-if relates-to-actor-via(:author)

  ; Only admins can destroy (handled by bypass)
  |policy :action-type destroy
    |forbid-if always
```

---

## Puzzle Piece 7: Schema Evolution

How do you express changes over time?

```udon
|field[full-name]
  :type string
  :was name                   ; renamed from :name
  :since 2.0.0

|field[legacy-field]
  :type string
  :deprecated 2.0.0
  :removed 3.0.0
  :migration "Use :new-field instead"

|field[api-key]
  :type string
  :sensitive
  :since 1.5.0
```

**Questions:**
- How does the runtime handle `was:` (read old data as new name)?
- How do migrations get generated from evolution metadata?
- Is version a resource-level or field-level concept?

---

## Puzzle Piece 8: Soft Regions (The Hard/Soft Boundary)

From the guarantees discussion: documents have "hard" parts (constrained,
machine-consumed) and "soft" parts (flexible, human-consumed).

How do you express "prose is allowed here"?

```udon
; Option A: Special marker
|schema[experiment]
  |experiment
    :status! @[experiment-status]    ; hard
    :traffic-allocation! number      ; hard

    |hypothesis!
      _prose+                        ; soft: free prose allowed
      |metric*                       ; hard: metrics have structure

; Option B: Trait
|schema[experiment]
  |experiment
    |hypothesis!.prose               ; .prose trait means soft content

; Option C: Attribute
|schema[experiment]
  |experiment
    |hypothesis! :allows-prose true

; Option D: Absence of constraint = soft
; If no children specified, any content allowed
|schema[experiment]
  |experiment
    |hypothesis!                     ; no children specified = prose OK
    |results!                        ; no children specified = prose OK
      |metric*                       ; but metrics are constrained
```

---

## Puzzle Piece 9: Storage Projection

How does one UDON resource definition project to multiple stores?

```udon
|resource[User]
  :stores
    |sequel :database main :primary
    |sequel :database read-replica :read-only
    |jsonl :path audit/users.jsonl :append-only

  |field[email]! :type string
  ; ...
```

Or is store configuration separate from schema?

```udon
; user.schema.udon - the resource definition
|resource[User]
  |field[email]! :type string
  ; ...

; stores.udon - deployment configuration
|store-config
  |resource @[User]
    |sequel :database main :primary
    |jsonl :path audit/users.jsonl :append-only
```

---

## Puzzle Piece 10: Derivation Targets

What gets generated from a UDON resource definition?

```
|resource[User]
    ↓
├── SQL DDL
│   CREATE TABLE users (
│     id UUID PRIMARY KEY,
│     email VARCHAR NOT NULL,
│     ...
│   );
│
├── JSON Schema
│   {
│     "type": "object",
│     "required": ["id", "email"],
│     "properties": { ... }
│   }
│
├── Ruby Class
│   class User < Archema::Resource
│     field :email, :string
│     ...
│   end
│
├── API Tool Definition
│   {
│     "name": "create_user",
│     "parameters": { ... }
│   }
│
├── Migration (on change)
│   ALTER TABLE users ADD COLUMN ...
│
└── Documentation
    (extracted from prose in definition)
```

---

## Puzzle Piece 11: The Self-Describing Layer

If UDON documents describe resources, what describes the UDON schema language
itself?

```udon
; meta-schema: the schema for schemas
|schema[udon-schema]
  |schema
    :id! string

    |field*
      :name! string
      :type! @[type-reference]
      :required? boolean
      :default? any
      ; ...

    |constraints?
      |one-of*
      |any-of*
      |when*
      ; ...

    |relationships?
      |belongs-to*
      |has-many*
      ; ...
```

The meta-schema validates schema documents. Schema documents validate instance
documents. It's schemas all the way up.

---

## The Unification Intuition

What Joseph is sensing (my interpretation):

**Everything is a UDON document:**
- Instance data
- Schema definitions
- Resource definitions (schema + behavior)
- Type definitions
- Store configurations
- Query results
- Validation errors
- Migration plans

**One notation, multiple interpretations:**
- Same AST, different consumers
- The parser doesn't know if it's parsing data or schema or config
- Semantics come from context (what schema is applied, what consumer interprets)

**Declarative over imperative:**
- You declare what things are
- Behavior is derived from declarations
- Imperative code is the escape hatch, not the default

**The Archema principle extended:**
- "Resources are the single source of truth"
- becomes "UDON definitions are the single source of truth"
- SQL, JSON Schema, Ruby classes, APIs all derive from UDON

---

## Puzzle Piece 12: Dialect Declarations

UDON documents may need to declare what "kind" of UDON they are — similar to
XML namespaces/declarations, but hopefully more elegant.

**What a dialect declaration conveys:**
- What kind of UDON document is this?
- Where to find the spec/schema for this dialect
- Which version of the dialect
- Possibly: what consistency profile applies

**Basic syntax (TBD):**

```udon
!dialect archema/resource :version 2.0.0 :spec https://archema.dev/spec

|resource[User]
  ; ...
```

**Dialect switching within a document:**

A single document can switch dialects, enabling self-documenting schemas:

```udon
!dialect udon/schema

|schema[user]
  |user
    :email! string
    :name! string
    :role? @[user-role]

|type[user-role]
  :enum [admin author reader]

!dialect @[user]              ; switch to instance mode

|user
  :email alice@example.com
  :name Alice
  :role admin

|user
  :email bob@example.com
  :name Bob
```

**Scoped dialect switching:**

Dialects can be scoped to subtrees:

```udon
|document
  |schema !dialect udon/schema
    |user
      :email! string
      :name! string

  |examples !dialect :schema @[user]
    |user :email alice@example.com :name Alice
    |user :email bob@example.com :name Bob

  |tests
    |valid !dialect :schema @[user]
      |user :email a@b.com :name A

    |invalid !dialect :schema @[user] :expect-errors true
      |user :name "Missing required email"
```

**What this enables:**
- Self-documenting schemas (define + examples in one file)
- Test fixtures (schema + valid/invalid cases)
- Tutorials (schema + walked examples + prose)
- Archema resources with seed data and tests
- Migrations (old schema + new schema + transformations)

**The dialect as lens:**

Same UDON syntax, same parser, same AST — but interpreted differently:
- In `udon/schema` dialect: `|user` defines a schema
- In `@[user]` instance dialect: `|user` is validated data
- In `archema/resource` dialect: `|resource` defines behavior + structure

---

## Puzzle Piece 13: Provenance and Confidence

For agentic contexts, documents may need to declare who/what created them and
with what confidence:

```udon
!dialect archema/resource
!provenance :author opus-4.5 :confidence 0.9 :reviewed false

|resource[User]
  |field[email]! :type string

  |field[retention-days]? :type integer
    ;? uncertain about default — needs domain expert
    :default 90
```

**Provenance metadata might include:**
- Author (human, agent, system)
- Creation timestamp
- Confidence level (0.0-1.0)
- Review status
- Source/derivation (what was this based on?)

**Section-level confidence:**

```udon
|resource[User]
  |field[email]! :type string          ; high confidence, well understood

  |field[retention-days]? :type integer
    :$confidence 0.6                   ; uncertain
    :$needs-review true
    :default 90

  |policies
    :$confidence 0.4                   ; very uncertain, placeholder
    |policy :action-type read
      |authorize-if always
```

The `;?` uncertainty marker from feedback.md could be formalized:

```udon
;? comment                 ; uncertain, needs review
;?? comment                ; very uncertain, likely wrong
;! comment                 ; important, reviewer attention needed
```

---

## Open Questions

1. **Syntax for type references:** `@[type]`, `-> @[Type]`, `:type Type`?

2. **Inline vs separate:** Do constraints, relationships, actions live inside
   the element definition or alongside it?

3. **Soft region syntax:** How do you declare "prose allowed here"?

4. **Evolution metadata:** Field-level or resource-level? How does `was:` work
   at runtime?

5. **Cross-file references:** How does `-> @[User]` resolve when User is in
   another file?

6. **The meta-schema:** Is there a fixed meta-schema, or is it extensible?

7. **Compilation pipeline:** What's the order of operations? Parse → validate
   against meta-schema → derive targets?

8. **Behavioral escape hatches:** Inline code, external references, or both?
   What's the syntax?

9. **Store configuration:** Part of resource definition or separate deployment
   config?

10. **Versioning:** Schema version vs resource version vs document version?

11. **Dialect declaration syntax:** `!dialect ...`? Shebang? Special element?

12. **Dialect scoping:** Document-level only, or subtree-scoped? Both?

13. **Dialect references:** `!dialect @[user]` references a schema in the same
    document — how does cross-file dialect reference work?

14. **Provenance granularity:** Document-level, element-level, attribute-level?

15. **Confidence semantics:** What does confidence 0.7 *mean*? How do tools use it?

16. **Uncertainty markers:** Formalize `;?` and `;??`? What's the taxonomy?

---

## Next Steps (Not Prescribed)

- Look at the pieces together, rearrange mentally
- Identify which pieces are essential vs nice-to-have
- Find the minimal coherent core
- Let the elegant unification emerge rather than forcing it

---

*This document is a workspace, not a conclusion.*
