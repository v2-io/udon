---
source: rowan — schema decision log, ~/src/rowan/lib/archema/schema/decision_log.rb
gathered: 2026-07-21
status: gathered (verbatim copy)
paths:
  - rowan/lib/archema/schema/decision_log.rb
source_commit: 0ecf61a (rowan)
categories: [decisions-as-durable-artifacts, replayable-migrations, audit-trail, agent-decision-sources]
why_included: >
  Decisions-as-durable-replayable-artifacts: resolve rename-vs-drop+add ONCE, persist to .archema/decisions.yaml (committed), replay deterministically in CI. Decision SOURCES incl. :agent_comment (agent embeds '# {{replaces: :old_name}}' in code) and :interactive — directly a harness pattern for making an agent's ambiguity-resolution durable and auditable.
---

# frozen_string_literal: true

# rbs_inline: enabled

require "yaml"
require "fileutils"
require "time"
require "securerandom"

module Archema
  module Schema
    # Persistent record of decisions made when resolving ambiguous schema changes.
    #
    # ## Purpose
    #
    # Schema evolution often faces ambiguity: when an attribute disappears and
    # another appears, is that a rename or a separate remove+add? The differ
    # cannot know without context. This log captures the human (or agent)
    # decisions so they can be:
    #
    # 1. **Replayed** - Regenerate migrations deterministically in CI/CD
    # 2. **Audited** - Understand why a migration looks the way it does
    # 3. **Learned from** - Future heuristics could train on decision patterns
    #
    # ## Decision Sources
    #
    # Decisions enter the system through multiple channels:
    #
    # - **:interactive** - Human responded to a terminal prompt
    # - **:agent_comment** - Agent embedded `# {{replaces: :old_name}}` in code
    # - **:config** - CI/CD pipeline provided answer via config file
    # - **:cli** - Command-line argument specified the resolution
    # - **:auto** - No ambiguity existed; system determined answer automatically
    #
    # ## File Location
    #
    # Decisions persist to `.archema/decisions.yaml` - a YAML file that should
    # be committed to version control. This ensures all developers and CI get
    # the same migration output from the same schema changes.
    #
    # @example Recording a decision interactively
    #   log = DecisionLog.load
    #   log.record!(
    #     resource: "AgentCard",
    #     ambiguity_type: :possible_rename,
    #     decision: :rename,
    #     context: { from: :name, to: :full_name },
    #     source: :interactive,
    #     reason: "User confirmed this was a rename during development"
    #   )
    #   log.save!
    #
    # @example Looking up a prior decision (for replay)
    #   decision = log.find_decision(
    #     resource: "AgentCard",
    #     ambiguity_type: :possible_rename,
    #     removed: :name,
    #     added: :full_name
    #   )
    #   # => Decision if found, nil if this ambiguity hasn't been decided
    #
    # @rbs!
    #   # Context values in decision records. Typically attribute names (symbols),
    #   # type names (symbols/strings), or collections of attribute names.
    #   type context_value = Symbol | String | Integer | Array[Symbol | String | Integer]
    #
    #   # YAML-serialized values after stringification. All keys become strings,
    #   # symbols become strings, nested hashes are recursively stringified.
    #   type yaml_scalar = String | Integer | nil
    #   type yaml_value = yaml_scalar | Array[yaml_scalar] | Hash[String, yaml_scalar | Array[yaml_scalar]]

    # Records decisions made when resolving ambiguous schema changes.
    # See module documentation above for full details.
    class DecisionLog
      # A single decision record capturing one resolved ambiguity.
      #
      # Decisions are immutable once recorded - we never edit history, only
      # append new decisions. This provides a reliable audit trail and ensures
      # that replaying schema evolution always produces the same result.
      #
      # ## Attributes
      #
      # - **id** - Time-sortable unique identifier (YYYYMMDDHHmmss-random)
      #   for deterministic ordering and easy human scanning of logs
      # - **resource** - Which Resource class this decision applies to
      # - **timestamp** - UTC time when the decision was made (for audit)
      # - **ambiguity_type** - Category of ambiguity (:possible_rename,
      #   :possible_type_change, :possible_split, etc.)
      # - **decision** - The chosen resolution (:rename, :separate,
      #   :type_change, :keep_both, etc.)
      # - **context** - Ambiguity-specific details like {from: :old, to: :new}
      # - **source** - How this decision entered the system (see class docs)
      # - **agent_id** - If an agent made this decision, which session/agent
      # - **reason** - Optional human-readable explanation for future readers
      Decision = Struct.new(
        :id,             #: String  -- time-sortable unique ID (YYYYMMDDHHmmss-XXXXXXXX)
        :resource,       #: Symbol  -- Resource class name (symbol for fast lookup)
        :timestamp,      #: Time?   -- UTC time recorded (nil only if malformed data)
        :ambiguity_type, #: Symbol  -- :possible_rename, :possible_type_change, :possible_split, etc.
        :decision,       #: Symbol  -- resolution: :rename, :separate, :type_change, :keep_both, etc.
        :context,        #: Hash[Symbol, context_value]?  -- e.g. {from: :old_name, to: :new_name}
        :source,         #: Symbol  -- :interactive, :agent_comment, :config, :cli, :auto
        :agent_id,       #: String? -- agent session ID (only when source is :agent_comment)
        :reason,         #: String? -- human-readable explanation for future maintainers
        keyword_init: true
      ) do
        # Serialize this decision to a YAML-safe hash for persistence.
        #
        # ## Why String Keys and Values?
        #
        # YAML serialization is most portable with string keys. While Ruby's
        # YAML can preserve symbols, other tools (and future Ruby versions)
        # may not. By normalizing to strings on write and symbolizing on read,
        # we ensure the decisions.yaml file is readable by any YAML parser
        # and survives format changes.
        #
        # ## Why .compact?
        #
        # Optional fields (agent_id, reason) may be nil. Rather than
        # cluttering the YAML with `agent_id: ~` for every decision,
        # we omit nil values entirely. This makes the file more readable
        # and reduces noise in version control diffs.
        #
        # @rbs return: Hash[String, yaml_value] -- YAML-safe hash ready for serialization
        def to_h
          {
            "id"             => id,
            "resource"       => resource.to_s,
            "timestamp"      => timestamp&.iso8601,
            "ambiguity_type" => ambiguity_type.to_s,
            "decision"       => decision.to_s,
            "context"        => stringify_keys(context || {}),
            "source"         => source.to_s,
            "agent_id"       => agent_id,
            "reason"         => reason
          }.compact
        end

        private

        # Recursively convert hash keys and symbol values to strings.
        #
        # Context hashes may contain nested structures (e.g., for complex
        # ambiguities involving multiple attributes). This ensures the
        # entire structure serializes cleanly to YAML without symbol tags.
        #
        # @rbs hash: Hash[Symbol, context_value] | context_value -- hash to stringify or pass-through value
        # @rbs return: Hash[String, yaml_value] | yaml_value -- stringified hash or converted value
        def stringify_keys(hash)
          return hash unless hash.is_a?(Hash)

          hash.transform_keys(&:to_s).transform_values do |v|
            case v
            when Hash then stringify_keys(v)
            when Symbol then v.to_s
            else v
            end
          end
        end
      end

      # Canonical list of valid decision sources.
      #
      # ## Why Enumerate Sources?
      #
      # Knowing where a decision came from enables:
      # - **Filtering** - Show all interactive decisions for review
      # - **Trust levels** - Auto decisions are system-verified; agent decisions may warrant scrutiny
      # - **Analytics** - Track how often ambiguity requires human intervention
      # - **Debugging** - When a migration behaves unexpectedly, trace back to its source
      #
      # ## Source Semantics
      #
      # - `:interactive` - A human at a terminal answered a prompt. High confidence, explicit choice.
      # - `:agent_comment` - An AI agent embedded `# {{replaces: :old_name}}` in code. Traceable via agent_id.
      # - `:config` - CI/CD pipeline provided answer via config file. Deterministic, auditable.
      # - `:cli` - Command-line argument specified resolution. Useful for scripted workflows.
      # - `:auto` - No ambiguity existed; system determined answer automatically. No human input needed.
      #
      # @rbs!
      #   type source_type = :interactive | :agent_comment | :config | :cli | :auto
      SOURCES = [:interactive, :agent_comment, :config, :cli, :auto].freeze #: Array[Symbol]

      # @rbs @decisions: Array[Decision]

      # All decisions in chronological order.
      #
      # Decisions are append-only and never modified after recording. This
      # provides a reliable audit trail for understanding why schema evolution
      # produced specific migrations.
      attr_reader :decisions #: Array[Decision]

      # Create a new DecisionLog, optionally with pre-existing decisions.
      #
      # ## Why Accept Pre-loaded Decisions?
      #
      # This enables the `from_hash` factory method to hydrate decisions from
      # YAML without exposing internal mutation. The decisions array is owned
      # by this instance and will only grow via `record!`.
      #
      # @rbs decisions: Array[Decision] -- pre-existing decisions (typically from deserialization)
      # @rbs return: void
      def initialize(decisions: []) = @decisions = decisions

      # Load the decision log from disk, creating an empty log if none exists.
      #
      # ## Why This Pattern?
      #
      # Schema evolution workflows need to work whether or not prior decisions
      # exist. A new project has no decision log; loading should succeed with
      # an empty log. An existing project may have accumulated hundreds of
      # decisions; loading should preserve them all.
      #
      # This "load or create" pattern means callers never need to check for
      # file existence—they just call `DecisionLog.load` and proceed.
      #
      # @rbs base_path: String? -- override the default `.archema/` directory
      # @rbs return: DecisionLog -- existing log or new empty log
      def self.load(base_path: nil)
        base_path   ||= default_base_path
        file_path   = decision_file_path(base_path)

        if File.exist?(file_path)
          from_file(file_path)
        else
          new
        end
      end

      # Load decisions from a YAML file.
      #
      # ## Why safe_load_file with permitted_classes?
      #
      # YAML.safe_load prevents arbitrary code execution from malicious YAML
      # (CVE-2013-0156 and friends). However, our decision files legitimately
      # contain Time objects for timestamps. By explicitly permitting only
      # Time, Date, DateTime, and Symbol, we get both safety and functionality.
      #
      # @rbs file_path: String -- absolute or relative path to decisions.yaml
      # @rbs return: DecisionLog
      def self.from_file(file_path)
        data = YAML.safe_load_file(file_path, permitted_classes: [Time, Date, DateTime, Symbol])
        from_hash(data)
      end

      # Reconstruct a DecisionLog from a deserialized hash.
      #
      # ## Why Symbolize on Load?
      #
      # YAML files store everything as strings for maximum portability. But
      # internal code works more naturally with symbols (faster comparison,
      # clearer semantics for enums like ambiguity_type). This method bridges
      # the storage format to the runtime format.
      #
      # ## Defensive Handling
      #
      # - `&.to_sym` handles nil values gracefully (malformed data)
      # - `|| {}` ensures context is always a hash even if omitted
      # - `parse_time` handles both Time objects and ISO8601 strings
      #
      # @rbs data: Hash[String, yaml_value | Array[Hash[String, yaml_value]]] -- deserialized YAML structure
      # @rbs return: DecisionLog -- fully hydrated log ready for use
      def self.from_hash(data)
        decisions = (data["decisions"] || []).map do |d|
          Decision.new(
            id:             d["id"],
            resource:       d["resource"]&.to_sym,
            timestamp:      parse_time(d["timestamp"]),
            ambiguity_type: d["ambiguity_type"]&.to_sym,
            decision:       d["decision"]&.to_sym,
            context:        symbolize_keys(d["context"] || {}),
            source:         d["source"]&.to_sym,
            agent_id:       d["agent_id"],
            reason:         d["reason"]
          )
        end

        new(decisions: decisions)
      end

      # Record a new decision, appending it to the log.
      #
      # ## Why record! (with bang)?
      #
      # The bang indicates mutation—this method modifies the DecisionLog
      # instance by appending a new decision. The change is not persisted
      # until `save!` is called, allowing batch recording of multiple
      # decisions before writing to disk.
      #
      # ## Why Return the Decision?
      #
      # Callers often need immediate access to the recorded decision (e.g.,
      # to log its ID or display confirmation). Returning the decision avoids
      # a second lookup.
      #
      # @rbs resource: String | Symbol -- Resource class name this decision applies to
      # @rbs ambiguity_type: Symbol -- category of ambiguity (:possible_rename, :possible_type_change, etc.)
      # @rbs decision: Symbol -- chosen resolution (:rename, :separate, :type_change, etc.)
      # @rbs context: Hash[Symbol, context_value] -- ambiguity-specific details ({from: :old, to: :new})
      # @rbs source: Symbol -- how decision entered system (see SOURCES constant)
      # @rbs agent_id: String? -- agent session ID if source is :agent_comment
      # @rbs reason: String? -- human-readable explanation for future maintainers
      # @rbs return: Decision -- the newly created decision record
      def record!(resource:, ambiguity_type:, decision:, context: {}, source: :interactive, agent_id: nil, reason: nil)
        decision_record = Decision.new(
          id:             generate_id,
          resource:       resource.to_sym,
          timestamp:      Time.now.utc,
          ambiguity_type: ambiguity_type,
          decision:       decision,
          context:        context,
          source:         source,
          agent_id:       agent_id,
          reason:         reason
        )

        @decisions << decision_record
        decision_record
      end

      # Find a prior decision for a specific ambiguity scenario.
      #
      # ## Why This Lookup Pattern?
      #
      # During schema evolution replay (e.g., regenerating migrations in CI),
      # we encounter the same ambiguities that were previously resolved. This
      # method finds the matching prior decision so we can apply the same
      # resolution automatically.
      #
      # ## Context Matching Strategy
      #
      # Different tools may use different key names for the same concept:
      # - `from`/`to` (rename semantics)
      # - `removed`/`added` (diff semantics)
      #
      # We check both to ensure decisions match regardless of how the
      # ambiguity was originally recorded.
      #
      # @rbs resource: String | Symbol -- Resource class name to search within
      # @rbs ambiguity_type: Symbol -- type of ambiguity to match
      # @rbs removed: Symbol? -- the removed/from attribute name
      # @rbs added: Symbol? -- the added/to attribute name
      # @rbs return: Decision? -- matching decision or nil if not found
      def find_decision(resource:, ambiguity_type:, removed: nil, added: nil)
        resource_sym = resource.to_sym
        removed_sym  = removed&.to_sym
        added_sym    = added&.to_sym

        decisions.find do |d|
          d.resource == resource_sym &&
            d.ambiguity_type == ambiguity_type &&
            matches_context_value?(d.context, [:from, :removed], removed_sym) &&
            matches_context_value?(d.context, [:to, :added], added_sym)
        end
      end

      private

      # Check if a context hash contains an expected value under any of several keys.
      #
      # ## Why Multiple Keys?
      #
      # Context hashes may use different key names for the same concept
      # depending on the source. A rename might be recorded as `{from: :old}`
      # or `{removed: :old}`. This helper abstracts over that variation.
      #
      # ## Why Return True for nil Expected?
      #
      # When a caller doesn't care about a particular field (passes nil),
      # any value in the context is acceptable. This enables partial matching.
      #
      # @rbs context: Hash[Symbol, context_value]? -- decision context to search
      # @rbs keys: Array[Symbol] -- alternative key names to check
      # @rbs expected: Symbol? -- value to match (nil means "don't care")
      # @rbs return: bool -- true if any key contains the expected value
      def matches_context_value?(context, keys, expected)
        return true if expected.nil?

        keys.any? do |key|
          value = context[key]
          next false if value.nil?

          value.to_sym == expected
        end
      end

      public

      # Filter decisions to only those affecting a specific Resource.
      #
      # Useful for reviewing all schema evolution decisions for a single
      # Resource, or for scoping analysis to one part of the domain.
      #
      # @rbs resource: String | Symbol -- Resource class name to filter by
      # @rbs return: Array[Decision] -- decisions affecting this resource
      def for_resource(resource)
        resource_sym = resource.to_sym
        decisions.select { |d| d.resource == resource_sym }
      end

      # Filter decisions by ambiguity type.
      #
      # Useful for analyzing patterns—e.g., "how often do we rename vs.
      # remove+add?" or "are type changes common in this codebase?"
      #
      # @rbs type: Symbol -- ambiguity type to filter by (:possible_rename, etc.)
      # @rbs return: Array[Decision] -- decisions of this type
      def by_type(type) = decisions.select { |d| d.ambiguity_type == type }

      # Filter decisions by their source.
      #
      # Useful for auditing—e.g., "show me all decisions made by AI agents"
      # or "which decisions came from interactive prompts?"
      #
      # @rbs source: Symbol -- source to filter by (see SOURCES constant)
      # @rbs return: Array[Decision] -- decisions from this source
      def from_source(source) = decisions.select { |d| d.source == source }

      # Serialize the entire log to a portable hash structure.
      #
      # ## Structure
      #
      # ```yaml
      # version: "1.0.0"
      # updated_at: "2024-01-15T10:30:00Z"
      # decisions:
      #   - id: "20240115103000-a1b2c3d4"
      #     resource: "AgentCard"
      #     ...
      # ```
      #
      # ## Why Include Version?
      #
      # Future schema evolution changes may require new decision fields or
      # different serialization formats. The version field enables safe
      # migration of old decision logs to new formats.
      #
      # ## Why updated_at?
      #
      # Tracks when the log was last modified. Useful for debugging ("when
      # was this changed?") and for determining if a log needs to be merged
      # with changes from another branch.
      #
      # @rbs return: Hash[String, String | Array[Hash[String, yaml_value]]] -- portable structure ready for YAML serialization
      def to_h = { "version"    => "1.0.0", "updated_at" => Time.now.utc.iso8601, "decisions" => decisions.map(&:to_h) }

      # Serialize to YAML string.
      #
      # The resulting string is ready to write to disk and be read by any
      # YAML parser. All values are strings or primitive types.
      #
      # @rbs return: String -- complete YAML document
      def to_yaml = to_h.to_yaml

      # Persist the decision log to disk.
      #
      # ## Why save! (with bang)?
      #
      # Indicates a side effect (disk I/O) and potential failure (permissions,
      # disk full). The bang warns callers that this operation may raise.
      #
      # ## Why Return the Path?
      #
      # Callers often want to log or display where the file was written.
      # Returning the path avoids redundant path computation.
      #
      # ## Directory Creation
      #
      # The `.archema/` directory may not exist yet (new project). We create
      # it automatically so callers don't need to handle this edge case.
      #
      # @rbs base_path: String? -- override the default `.archema/` directory
      # @rbs return: String -- absolute path to the written file
      def save!(base_path: nil)
        base_path   ||= self.class.default_base_path
        file_path   = self.class.decision_file_path(base_path)

        dir = File.dirname(file_path)
        FileUtils.mkdir_p(dir)

        File.write(file_path, to_yaml)
        file_path
      end

      class << self
        # Default location for Archema metadata files.
        #
        # Convention: `.archema/` in the project root, similar to `.git/`.
        # This keeps schema evolution artifacts organized and easy to gitignore
        # selectively (e.g., ignore snapshots but commit decisions).
        #
        # @rbs return: String -- absolute path to `.archema/` directory
        def default_base_path = File.join(Dir.pwd, ".archema")

        # Path to the decision log file within a base path.
        #
        # @rbs base_path: String -- parent directory for Archema files
        # @rbs return: String -- path to `decisions.yaml`
        def decision_file_path(base_path) = File.join(base_path, "decisions.yaml")

        private

        # Parse a timestamp from YAML, handling both Time objects and strings.
        #
        # ## Why Both Formats?
        #
        # YAML.safe_load with `permitted_classes: [Time]` may parse timestamps
        # directly to Time objects, or leave them as strings depending on the
        # YAML format. This method normalizes both to Time.
        #
        # ## Why Return nil on Failure?
        #
        # Invalid timestamp data shouldn't prevent loading the entire log.
        # The decision is still usable even with a nil timestamp—we just lose
        # audit trail precision.
        #
        # @rbs value: String | Time | nil -- raw timestamp from YAML
        # @rbs return: Time? -- parsed UTC time or nil if unparseable
        def parse_time(value)
          return nil if value.nil?
          return value if value.is_a?(Time)

          Time.parse(value.to_s)
        rescue ArgumentError
          nil
        end

        # Recursively convert string keys to symbols for internal use.
        #
        # ## Why Symbolize?
        #
        # Internal code uses symbols for hash keys (clearer semantics,
        # faster comparison). YAML stores strings. This bridges the gap.
        #
        # ## Why Recursive?
        #
        # Context hashes may be nested (e.g., type change with nested
        # structure details). We need to symbolize at all levels.
        #
        # @rbs hash: Hash[String, yaml_value] | yaml_value -- YAML-parsed structure or pass-through value
        # @rbs return: Hash[Symbol, context_value] | context_value -- symbolized structure or converted value
        def symbolize_keys(hash)
          return hash unless hash.is_a?(Hash)

          hash.transform_keys(&:to_sym).transform_values do |v|
            case v
            when Hash then symbolize_keys(v)
            else v
            end
          end
        end
      end

      private

      # Generate a time-sortable unique identifier.
      #
      # ## ID Format: YYYYMMDDHHmmss-XXXXXXXX
      #
      # Example: `20240115103045-a1b2c3d4`
      #
      # ## Why This Format?
      #
      # 1. **Time-sortable**: IDs naturally sort chronologically when viewed
      #    in file listings or log output. Humans can scan timestamps at a glance.
      #
      # 2. **Human-readable**: Unlike UUIDs, you can immediately see when a
      #    decision was made without parsing.
      #
      # 3. **Unique**: The 8 hex chars (32 bits of randomness) prevent collisions
      #    even if two decisions are recorded in the same second.
      #
      # 4. **Compact**: 23 characters vs 36 for a UUID. Fits better in logs.
      #
      # @rbs return: String -- unique identifier like "20240115103045-a1b2c3d4"
      def generate_id
        timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
        random    = SecureRandom.hex(4)
        "#{timestamp}-#{random}"
      end
    end
  end
end
