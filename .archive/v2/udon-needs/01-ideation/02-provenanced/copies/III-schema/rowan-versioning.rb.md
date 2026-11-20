---
source: rowan (ex-Archema) — the schema versioning DSL, ~/src/rowan/lib/archema/resource/versioning.rb
gathered: 2026-07-21
status: gathered (verbatim copy)
paths:
  - rowan/lib/archema/resource/versioning.rb
source_commit: 0ecf61a (rowan)
categories: [schema-versioning, upcast-on-read, semver-compat, self-describing-documents, first-waiting-customer]
why_included: >
  The working schema_id/schema_version DSL: upcast from:, backward/forward_compatible_with, since:/deprecated: per-attribute, runtime evolve (add/rename/split_field), _schema:type/version self-describing pattern. Copied whole — the docstring examples ARE the demand shape; this is the schema layer's 'first waiting customer' for UDON. (.rb copied verbatim; agentic-tooling readers who don't touch Ruby can read the doc-comments alone.)
---

# frozen_string_literal: true

# rbs_inline: enabled

module Archema
  module ResourceDSL
    # Schema versioning DSL for Resources
    #
    # Provides version tracking, upcasting (migration on read), and
    # compatibility declarations. Enables the `_schema: type/version`
    # pattern for self-describing documents.
    #
    # This is the foundation for:
    # - ADR-008 P4: Versioned Document System
    # - Event sourcing with schema evolution
    # - Protobuf-style compatibility semantics
    #
    # @example Basic versioning
    #   class AgentCard < Archema::Resource
    #     schema_id "autopax-agent-card"
    #     schema_version "2.0.0"
    #
    #     attributes do
    #       attribute :name, :string
    #       attribute :model, :hash  # Was flat string in v1
    #     end
    #
    #     upcast from: "1" do |data|
    #       # Transform v1 flat model string to v2 nested hash
    #       if data[:model].is_a?(String)
    #         match = data[:model].match(/@([^\/]+)\/(.+)/)
    #         data[:model] = { substrate: match[1], variant: match[2] }
    #       end
    #       data
    #     end
    #   end
    #
    # @example With compatibility declarations
    #   class Entry < Archema::Resource
    #     schema_id "chronica-entry"
    #     schema_version "3.0.0"
    #
    #     backward_compatible_with "1.0.0", "2.0.0"
    #
    #     attributes do
    #       attribute :content, :string
    #       attribute :session_id, :uuid8, since: "2.0.0"
    #       attribute :context, :hash, since: "3.0.0", default: -> { {} }
    #       attribute :legacy_tags, :array, deprecated: "3.0.0"
    #     end
    #   end
    #
    module Versioning
      module DSL
        def self.included(base) = base.extend(ClassMethods)

        module ClassMethods
          # Class#name is available since this module extends a Class
          # @rbs!
          #   def name: () -> String?

          # Set or get the schema identifier (type name)
          #
          # This is the "type" part of "_schema: type/version"
          # If not set, defaults to a snake_case version of the class name.
          #
          # @rbs id: String? -- the schema identifier
          # @rbs return: String -- the schema identifier
          #
          # @example
          #   schema_id "autopax-agent-card"
          #
          def schema_id(id = nil)
            if id
              @schema_id = id.to_s
            else
              @schema_id ||= default_schema_id
            end
          end

          # Set or get the current schema version
          #
          # Uses semantic versioning. This is the "version" part of
          # "_schema: type/version"
          #
          # @rbs version: String? -- the schema version (semver)
          # @rbs return: String -- the schema version
          #
          # @example
          #   schema_version "2.0.0"
          #
          def schema_version(version = nil)
            if version
              @schema_version = normalize_version(version)
            else
              @schema_version ||= "1.0.0"
            end
          end

          # Get the full schema identifier (type/version)
          #
          # This is what gets embedded in documents as `_schema`
          #
          # @rbs return: String -- e.g., "autopax-agent-card/2.0.0"
          #
          def full_schema_id = "#{schema_id}/#{schema_version}"

          # Declare backward compatibility with older versions
          #
          # Documents written by these versions can be read by this version.
          # Requires upcast blocks to transform old data.
          #
          # @param versions [Array<String>] versions this schema can read
          #
          # @example
          #   backward_compatible_with "1.0.0", "1.1.0", "2.0.0"
          #
          def backward_compatible_with(*versions)
            @backward_compatible_versions ||= []
            @backward_compatible_versions.concat(versions.map { |v| normalize_version(v) })
          end

          # Get list of backward compatible versions
          #
          # @rbs return: Array[String]
          def backward_compatible_versions = @backward_compatible_versions ||= []

          # Declare forward compatibility with future versions
          #
          # This version's output can be read by the specified future versions.
          # Primarily documentation; actual compatibility depends on those versions.
          #
          # @param versions [Array<String>] versions that can read this schema's output
          #
          def forward_compatible_with(*versions)
            @forward_compatible_versions ||= []
            @forward_compatible_versions.concat(versions.map { |v| normalize_version(v) })
          end

          # Get list of forward compatible versions
          #
          # @rbs return: Array[String]
          def forward_compatible_versions = @forward_compatible_versions ||= []

          # Define an upcast transformation from an older version
          #
          # Upcast blocks transform data from older schema versions to the
          # current version. They are applied in sequence when reading old data.
          #
          # @param from [String] the source version (or major version like "1")
          # @yield [Hash] the data hash to transform
          # @yieldreturn [Hash] the transformed data hash
          #
          # @example Upcast from v1 to current
          #   upcast from: "1" do |data|
          #     data.merge(new_field: "default_value")
          #   end
          #
          # @example Upcast from specific version
          #   upcast from: "1.2.0" do |data|
          #     # Transform 1.2.0 data
          #     data[:status] = data.delete(:legacy_status)
          #     data
          #   end
          #
          def upcast(from:, &block)
            raise ArgumentError, "upcast requires a block" unless block_given?

            @upcast_blocks             ||= {}
            normalized                 = normalize_version_prefix(from)
            @upcast_blocks[normalized] = block
          end

          # Get all upcast blocks
          #
          # @rbs return: Hash[String, Proc]
          def upcast_blocks = @upcast_blocks ||= {}

          # Check if we can read data from a specific version
          #
          # @rbs version: String -- the version to check
          # @rbs return: bool
          #
          def can_read_version?(version)
            normalized = normalize_version(version)
            return true if normalized == schema_version
            return true if backward_compatible_versions.include?(normalized)

            # Check if we have an upcast path
            upcast_path(version).any?
          end

          # Get the upcast path from a version to current
          #
          # Returns the sequence of upcast blocks to apply. For multi-version
          # evolution (e.g., 1.0.0 → 1.1.0 → 1.2.0), returns all intermediate
          # blocks in order.
          #
          # @rbs from_version: String -- the source version
          # @rbs return: Array[Proc] -- the upcast blocks to apply in order
          #
          def upcast_path(from_version)
            normalized = normalize_version(from_version)
            return [] if normalized == schema_version

            path = []

            # Get all versions in order
            all_versions = known_versions

            # Find starting position (where the stored version is)
            start_idx = all_versions.index(normalized)

            if start_idx
              # Collect upcast blocks from start to current (exclusive)
              # Each block transforms from its version to the next
              all_versions[start_idx...-1].each do |version|
                block = upcast_blocks[version] || upcast_blocks[major_version(version).to_s]
                path << block if block
              end
            else
              # Version not in known list, try exact or major match
              major = major_version(from_version)
              if upcast_blocks[normalized]
                path << upcast_blocks[normalized]
              elsif upcast_blocks[major.to_s]
                path << upcast_blocks[major.to_s]
              end
            end

            path
          end

          # Apply upcasting to transform old data to current schema
          #
          # @rbs data: Hash[Symbol, untyped] -- the data to transform
          # @rbs from_version: String? -- the source version
          # @rbs return: Hash[Symbol, untyped] -- the transformed data
          #
          def upcast_data(data, from_version)
            return data if from_version.nil?

            normalized = normalize_version(from_version)
            return data if normalized == schema_version

            result = data.dup
            upcast_path(from_version).each do |block|
              result = block.call(result)
            end
            result
          end

          # Check compatibility between two versions
          #
          # @rbs from: String -- source version
          # @rbs to: String? -- target version
          # @rbs return: Hash[Symbol, untyped] -- compatibility info
          #
          def check_compatibility(from:, to: nil)
            to              ||= schema_version
            from_normalized = normalize_version(from)
            to_normalized   = normalize_version(to)

            {
              from:                from_normalized,
              to:                  to_normalized,
              backward_compatible: can_read_version?(from),
              upcast_required:     from_normalized != to_normalized,
              upcast_available:    upcast_path(from).any?
            }
          end

          # Get all known versions (current + backward compatible)
          #
          # @rbs return: Array[String]
          def known_versions = ([schema_version] + backward_compatible_versions).uniq.sort_by { |v| Gem::Version.new(v) }

          # Mutate resource definition at runtime (ADR-004 Phase 3)
          #
          # Allows evolving a resource's schema while the process is running.
          # Existing in-memory records are automatically upcasted on next read.
          #
          # Thread-safe: Uses mutex to prevent concurrent evolution.
          #
          # @param new_version [String, nil] explicit version (auto-bumps minor if nil)
          # @yield DSL block for evolution operations
          #
          # @example Add a field
          #   User.evolve do
          #     add_field :display_name, :string, default: "Unknown"
          #   end
          #
          # @example Rename a field
          #   User.evolve do
          #     rename_field :name, to: :full_name
          #   end
          #
          # @example Split a field
          #   User.evolve do
          #     split_field :name, into: [:first_name, :last_name],
          #                 using: ->(v) { v.to_s.split(" ", 2) }
          #   end
          #
          def evolve(new_version: nil, &block)
            raise ArgumentError, "evolve requires a block" unless block_given?

            @evolve_mutex ||= Mutex.new

            @evolve_mutex.synchronize do
              from_version = schema_version
              to_version   = new_version ? normalize_version(new_version) : bump_minor_version(from_version)

              # Execute evolution in a context that captures changes
              context = EvolutionContext.new(self, from_version, to_version)
              context.instance_eval(&block)

              # Apply captured changes
              context.apply!

              # Update schema version
              @schema_version = to_version

              # Add from_version to backward compatible list
              backward_compatible_with(from_version)
            end
          end

          private

          # Bump the minor version (1.0.0 -> 1.1.0)
          #
          # @rbs version: String
          # @rbs return: String
          def bump_minor_version(version)
            parts    = version.split(".")
            parts[1] = (parts[1].to_i + 1).to_s
            parts[2] = "0"
            parts.join(".")
          end

          def default_schema_id
            if name.nil?
              "anonymous-resource-#{object_id}"
            else
              name.split("::").last
                  .gsub(/([a-z])([A-Z])/, '\1-\2')
                  .downcase
            end
          end

          def normalize_version(version)
            v     = version.to_s.strip
            parts = v.split(".")
            case parts.length
            when 1 then "#{parts[0]}.0.0"
            when 2 then "#{parts[0]}.#{parts[1]}.0"
            else v
            end
          end

          def normalize_version_prefix(version)
            v = version.to_s.strip
            # If it's just a major version like "1", keep it that way
            # for matching purposes
            return v if v.match?(/^\d+$/)

            normalize_version(v)
          end

          def major_version(version) = normalize_version(version).split(".").first.to_i
        end
      end
    end
  end
end
