---
source: rowan — schema change differ, ~/src/rowan/lib/archema/schema/differ.rb
gathered: 2026-07-21
status: gathered (verbatim copy)
paths:
  - rowan/lib/archema/schema/differ.rb
source_commit: 0ecf61a (rowan)
categories: [schema-diff, rename-detection, expand-contract, conflict-resolution, decision-log]
why_included: >
  Taxonomy of schema CHANGES + rename-detection heuristics (was:-hint vs 1-removed+1-added ambiguity vs multiple=separate) + the :possible_rename/:type_change conflict types requiring human/agent resolution + the expand/contract safe-evolution pattern. The header doc-comment (L1-59) is the demand digest; body is mechanism.
---

# frozen_string_literal: true

# rbs_inline: enabled

module Archema
  module Schema
    # Compares snapshots and produces migration operations.
    #
    # The differ is the brain of the migration system. It compares two snapshots
    # (or a snapshot against nil for initial creation) and produces a list of
    # operations that would transform the old schema to the new one.
    #
    # ## Rename Detection Heuristics
    #
    # | Scenario | Detection | Resolution |
    # |----------|-----------|------------|
    # | `was:` hint | Explicit rename via DSL | Auto-generates RenameColumn |
    # | 1 removed + 1 added, same type | Possible rename conflict | User chooses :rename or :separate |
    # | Multiple removed/added | Treated as separate drop+add | No rename detection |
    # | Type changed | Conflict requiring confirmation | User must choose :alter or :abort |
    #
    # ## Conflict Types
    #
    # - `:possible_rename` — Ambiguous: could be rename or drop+add; options: [:rename, :separate]
    # - `:type_change` — Column type changed; options: [:alter, :abort]
    #
    # ## Expand/Contract Pattern
    #
    # For safe schema evolution, use two migrations:
    # 1. **Expand:** Add new column (nullable or with default), deploy code that writes both
    # 2. **Contract:** Remove old column after all code uses new column
    #
    # The differ does not enforce this pattern; it's a recommended practice.
    #
    # ### Example: Renaming email → contact_email
    #
    # ```ruby
    # # Migration 1 (Expand): Add new column, keep old
    # attribute :email, :string           # Keep for now
    # attribute :contact_email, :string   # Add new
    # # Deploy: Write to both, read from new with old fallback
    #
    # # Migration 2 (Contract): Remove old column
    # attribute :contact_email, :string   # Keep new
    # # (remove :email)
    # ```
    #
    # ## Decision Log Integration
    #
    # When conflicts are resolved, `Schema::DecisionLog` records the choice:
    # - `archema codegen --resolve=rename` → logs decision to `.archema/decisions.yaml`
    # - Future diffs with same signature auto-apply the logged decision
    # - `DecisionLog#lookup(resource:, ambiguity_type:, context:)` checks for prior decisions
    #
    # @example Comparing snapshots
    #   diff = Differ.new(old_snapshot, new_snapshot)
    #   diff.operations  # => [AddColumn.new(...), RemoveColumn.new(...)]
    #   diff.conflicts   # => [Conflict.new(:possible_rename, {...})]
    #
    class Differ
      # Possible conflicts that require human resolution
      class Conflict
        # @rbs @type: Symbol
        # @rbs @details: Hash[Symbol, Symbol | String]
        # @rbs @options: Array[Symbol]

        attr_reader :type    #: Symbol
        attr_reader :details #: Hash[Symbol, Symbol | String]
        attr_reader :options #: Array[Symbol]

        # @rbs type: Symbol
        # @rbs details: Hash[Symbol, Symbol | String]
        # @rbs options: Array[Symbol]
        # @rbs return: void
        def initialize(type, details, options = [])
          @type    = type
          @details = details
          @options = options
        end

        # @rbs return: String
        def to_s = "#{type}: #{details}"
      end

      # @rbs @old_snapshot: Snapshot?
      # @rbs @new_snapshot: Snapshot
      # @rbs @operations: Array[Operation]
      # @rbs @conflicts: Array[Conflict]

      attr_reader :old_snapshot #: Snapshot?
      attr_reader :new_snapshot #: Snapshot
      attr_reader :operations   #: Array[Operation]
      attr_reader :conflicts    #: Array[Conflict]

      # @rbs old_snapshot: Snapshot?
      # @rbs new_snapshot: Snapshot
      # @rbs return: void
      def initialize(old_snapshot, new_snapshot)
        @old_snapshot = old_snapshot
        @new_snapshot = new_snapshot
        @operations   = []
        @conflicts    = []
        compute_diff!
      end

      # Check if there are changes
      #
      # @rbs return: bool
      def changes? = operations.any? || conflicts.any?

      # Check if there are unresolved conflicts
      #
      # @rbs return: bool
      def conflicts? = conflicts.any?

      # Resolve a conflict with a chosen option
      #
      # @rbs conflict: Conflict
      # @rbs choice: Symbol
      # @rbs return: void
      def resolve_conflict(conflict, choice)
        case conflict.type
        when :possible_rename
          if choice == :rename
            @operations << RenameColumn.new(
              table: new_snapshot.table_name,
              from:  conflict.details[:removed],
              to:    conflict.details[:added]
            )
          else
            @operations << RemoveColumn.new(
              table: new_snapshot.table_name,
              name:  conflict.details[:removed]
            )
            @operations << AddColumn.new(
              table: new_snapshot.table_name,
              name:  conflict.details[:added],
              **new_snapshot.attributes[conflict.details[:added]]
            )
          end
          @conflicts.delete(conflict)

        when :type_change
          raise "Cannot proceed without resolving type change for #{conflict.details[:column]}" unless choice == :alter

          @operations << AlterColumn.new(
            table:     new_snapshot.table_name,
            name:      conflict.details[:column],
            from_type: conflict.details[:from_type],
            to_type:   conflict.details[:to_type]
          )

          @conflicts.delete(conflict)
        end
      end

      private

      def compute_diff!
        if old_snapshot.nil?
          # New table
          @operations << CreateTable.new(
            table:       new_snapshot.table_name,
            attributes:  new_snapshot.attributes,
            primary_key: new_snapshot.primary_key
          )

          # Add indexes for identities
          add_identity_indexes(new_snapshot.identities)

          # Add foreign keys for relationships
          add_foreign_keys(new_snapshot.relationships)
        else
          diff_attributes
          diff_identities
          diff_relationships
        end
      end

      def diff_attributes
        old_attrs = old_snapshot.attributes
        new_attrs = new_snapshot.attributes

        removed = old_attrs.keys - new_attrs.keys
        added   = new_attrs.keys - old_attrs.keys
        common  = old_attrs.keys & new_attrs.keys

        # ISSUE-048 fix: First, check for explicit was: annotations
        # These are definitive renames that don't need user confirmation
        detect_explicit_renames(removed, added, old_attrs, new_attrs)

        # Then check for possible renames via heuristic (same type, one added, one removed)
        detect_possible_renames(removed, added, old_attrs, new_attrs)

        # Handle remaining additions
        added.each do |name|
          @operations << AddColumn.new(
            table: new_snapshot.table_name,
            name:  name,
            **new_attrs[name]
          )
        end

        # Handle remaining removals
        removed.each do |name|
          @operations << RemoveColumn.new(
            table: new_snapshot.table_name,
            name:  name
          )
        end

        # Check for modifications to existing columns
        common.each do |name|
          diff_column(name, old_attrs[name], new_attrs[name])
        end
      end

      # ISSUE-048 fix: Check for explicit was: annotations that definitively indicate renames
      # These don't require user confirmation because the developer explicitly declared the rename
      def detect_explicit_renames(removed, added, _old_attrs, new_attrs)
        added.dup.each do |new_name|
          new_attr = new_attrs[new_name]
          was_name = new_attr[:was_name]

          # If this attribute has was: annotation pointing to a removed column, it's a rename
          next unless was_name && removed.include?(was_name)

          # Auto-generate RenameColumn operation (no conflict needed)
          @operations << RenameColumn.new(
            table: new_snapshot.table_name,
            from:  was_name,
            to:    new_name
          )

          # Remove from add/remove lists so they're not processed again
          removed.delete(was_name)
          added.delete(new_name)
        end
      end

      def detect_possible_renames(removed, added, old_attrs, new_attrs)
        # Simple heuristic: if exactly one column removed and one added with same type,
        # ask if it's a rename
        return unless removed.size == 1 && added.size == 1

        removed_name = removed.first
        added_name   = added.first

        return unless old_attrs[removed_name][:type] == new_attrs[added_name][:type]

        @conflicts << Conflict.new(
          :possible_rename,
          { removed: removed_name, added: added_name },
          [:rename, :separate]
        )
        # Remove from the lists so they're not processed as add/remove
        removed.delete(removed_name)
        added.delete(added_name)
      end

      def diff_column(name, old_def, new_def)
        table = new_snapshot.table_name

        # Check type change
        if old_def[:type] != new_def[:type]
          # Type changes are dangerous, require confirmation
          @conflicts << Conflict.new(
            :type_change,
            {
              column:    name,
              from_type: old_def[:type],
              to_type:   new_def[:type]
            },
            [:alter, :abort]
          )
          return  # Don't process other changes until type is resolved
        end

        # Check nullability change
        if old_def[:allow_nil] != new_def[:allow_nil]
          @operations << AlterNullable.new(
            table:     table,
            name:      name,
            allow_nil: new_def[:allow_nil]
          )
        end

        # Check default change
        return unless old_def[:default] != new_def[:default]

        @operations << AlterDefault.new(
          table:   table,
          name:    name,
          default: new_def[:default]
        )
      end

      def diff_identities
        old_ids = old_snapshot&.identities || {}
        new_ids = new_snapshot.identities

        removed = old_ids.keys - new_ids.keys
        added   = new_ids.keys - old_ids.keys

        removed.each do |name|
          @operations << DropIndex.new(
            table: new_snapshot.table_name,
            name:  "idx_#{new_snapshot.table_name}_#{name}"
          )
        end

        added.each do |name|
          @operations << CreateUniqueIndex.new(
            table:   new_snapshot.table_name,
            name:    "idx_#{new_snapshot.table_name}_#{name}",
            columns: new_ids[name][:keys]
          )
        end
      end

      def diff_relationships
        old_rels = old_snapshot&.relationships || {}
        new_rels = new_snapshot.relationships

        # Only care about belongs_to (which creates foreign keys)
        old_belongs_to = old_rels.select { |_, r| r[:type] == :belongs_to }
        new_belongs_to = new_rels.select { |_, r| r[:type] == :belongs_to }

        removed = old_belongs_to.keys - new_belongs_to.keys
        added   = new_belongs_to.keys - old_belongs_to.keys

        removed.each do |name|
          @operations << DropForeignKey.new(
            table: new_snapshot.table_name,
            name:  "fk_#{new_snapshot.table_name}_#{name}"
          )
        end

        added.each do |name|
          rel = new_belongs_to[name]
          @operations << AddForeignKey.new(
            table:             new_snapshot.table_name,
            name:              "fk_#{new_snapshot.table_name}_#{name}",
            column:            rel[:source_attribute] || :"#{name}_id",
            references_table:  :"#{rel[:destination]}s",  # Simple pluralization
            references_column: rel[:destination_attribute] || :id
          )
        end
      end

      def add_identity_indexes(identities)
        identities.each do |name, id_def|
          @operations << CreateUniqueIndex.new(
            table:   new_snapshot.table_name,
            name:    "idx_#{new_snapshot.table_name}_#{name}",
            columns: id_def[:keys]
          )
        end
      end

      def add_foreign_keys(relationships)
        relationships.each do |name, rel_def|
          next unless rel_def[:type] == :belongs_to

          @operations << AddForeignKey.new(
            table:             new_snapshot.table_name,
            name:              "fk_#{new_snapshot.table_name}_#{name}",
            column:            rel_def[:source_attribute] || :"#{name}_id",
            references_table:  :"#{rel_def[:destination]}s",
            references_column: rel_def[:destination_attribute] || :id
          )
        end
      end

      # ─────────────────────────────────────────────────────────────────────────
      # Operation Classes
      # ─────────────────────────────────────────────────────────────────────────

      # Base class for schema operations
      class Operation
        # @rbs return: String
        def up = raise NotImplementedError

        # @rbs return: String
        def down = raise NotImplementedError
      end

      class CreateTable < Operation
        # @rbs @table: Symbol
        # @rbs @attributes: Hash[Symbol, Hash[Symbol, untyped]]
        # @rbs @primary_key: Symbol?

        attr_reader :table       #: Symbol
        attr_reader :attributes  #: Hash[Symbol, Hash[Symbol, untyped]]
        attr_reader :primary_key #: Symbol?

        # @rbs table: Symbol
        # @rbs attributes: Hash[Symbol, Hash[Symbol, untyped]]
        # @rbs primary_key: Symbol?
        # @rbs return: void
        def initialize(table:, attributes:, primary_key:)
          @table       = table
          @attributes  = attributes
          @primary_key = primary_key
        end
      end

      class DropTable < Operation
        attr_reader :table #: Symbol

        # @rbs table: Symbol
        # @rbs return: void
        def initialize(table:) = @table = table
      end

      class AddColumn < Operation
        # @rbs @table: Symbol
        # @rbs @name: Symbol
        # @rbs @type: Symbol
        # @rbs @allow_nil: bool
        # @rbs @default: untyped
        # @rbs @primary_key: bool
        # @rbs @generated: bool
        # @rbs @generation: Symbol?
        # @rbs @constraints: Hash[Symbol, untyped]

        attr_reader :table       #: Symbol
        attr_reader :name        #: Symbol
        attr_reader :type        #: Symbol
        attr_reader :allow_nil   #: bool
        attr_reader :default     #: untyped
        attr_reader :primary_key #: bool
        attr_reader :generated   #: bool
        attr_reader :generation  #: Symbol?
        attr_reader :constraints #: Hash[Symbol, untyped]

        # @rbs table: Symbol
        # @rbs name: Symbol
        # @rbs type: Symbol
        # @rbs allow_nil: bool
        # @rbs default: untyped
        # @rbs primary_key: bool
        # @rbs generated: bool
        # @rbs generation: Symbol?
        # @rbs constraints: Hash[Symbol, untyped]
        # @rbs return: void
        def initialize(table:, name:, type:, allow_nil: true, default: nil,
                       primary_key: false, generated: false, generation: nil,
                       constraints: {})
          @table       = table
          @name        = name
          @type        = type
          @allow_nil   = allow_nil
          @default     = default
          @primary_key = primary_key
          @generated   = generated
          @generation  = generation
          @constraints = constraints
        end
      end

      class RemoveColumn < Operation
        attr_reader :table #: Symbol
        attr_reader :name  #: Symbol

        # @rbs table: Symbol
        # @rbs name: Symbol
        # @rbs return: void
        def initialize(table:, name:)
          @table = table
          @name  = name
        end
      end

      class RenameColumn < Operation
        attr_reader :table #: Symbol
        attr_reader :from  #: Symbol
        attr_reader :to    #: Symbol

        # @rbs table: Symbol
        # @rbs from: Symbol
        # @rbs to: Symbol
        # @rbs return: void
        def initialize(table:, from:, to:)
          @table = table
          @from  = from
          @to    = to
        end
      end

      class AlterColumn < Operation
        attr_reader :table     #: Symbol
        attr_reader :name      #: Symbol
        attr_reader :from_type #: Symbol
        attr_reader :to_type   #: Symbol

        # @rbs table: Symbol
        # @rbs name: Symbol
        # @rbs from_type: Symbol
        # @rbs to_type: Symbol
        # @rbs return: void
        def initialize(table:, name:, from_type:, to_type:)
          @table     = table
          @name      = name
          @from_type = from_type
          @to_type   = to_type
        end
      end

      class AlterNullable < Operation
        attr_reader :table     #: Symbol
        attr_reader :name      #: Symbol
        attr_reader :allow_nil #: bool

        # @rbs table: Symbol
        # @rbs name: Symbol
        # @rbs allow_nil: bool
        # @rbs return: void
        def initialize(table:, name:, allow_nil:)
          @table     = table
          @name      = name
          @allow_nil = allow_nil
        end
      end

      class AlterDefault < Operation
        attr_reader :table   #: Symbol
        attr_reader :name    #: Symbol
        attr_reader :default #: untyped

        # @rbs table: Symbol
        # @rbs name: Symbol
        # @rbs default: untyped
        # @rbs return: void
        def initialize(table:, name:, default:)
          @table   = table
          @name    = name
          @default = default
        end
      end

      class CreateUniqueIndex < Operation
        attr_reader :table   #: Symbol
        attr_reader :name    #: String
        attr_reader :columns #: Array[Symbol]

        # @rbs table: Symbol
        # @rbs name: String
        # @rbs columns: Array[Symbol]
        # @rbs return: void
        def initialize(table:, name:, columns:)
          @table   = table
          @name    = name
          @columns = columns
        end
      end

      class DropIndex < Operation
        attr_reader :table #: Symbol
        attr_reader :name  #: String

        # @rbs table: Symbol
        # @rbs name: String
        # @rbs return: void
        def initialize(table:, name:)
          @table = table
          @name  = name
        end
      end

      class AddForeignKey < Operation
        attr_reader :table             #: Symbol
        attr_reader :name              #: String
        attr_reader :column            #: Symbol
        attr_reader :references_table  #: Symbol
        attr_reader :references_column #: Symbol

        # @rbs table: Symbol
        # @rbs name: String
        # @rbs column: Symbol
        # @rbs references_table: Symbol
        # @rbs references_column: Symbol
        # @rbs return: void
        def initialize(table:, name:, column:, references_table:, references_column:)
          @table             = table
          @name              = name
          @column            = column
          @references_table  = references_table
          @references_column = references_column
        end
      end

      class DropForeignKey < Operation
        attr_reader :table #: Symbol
        attr_reader :name  #: String

        # @rbs table: Symbol
        # @rbs name: String
        # @rbs return: void
        def initialize(table:, name:)
          @table = table
          @name  = name
        end
      end
    end
  end
end
