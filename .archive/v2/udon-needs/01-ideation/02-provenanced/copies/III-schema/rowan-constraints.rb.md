---
source: rowan — composition constraints DSL, ~/src/rowan/lib/archema/resource/constraints.rb
gathered: 2026-07-21
status: gathered (verbatim copy)
paths:
  - rowan/lib/archema/resource/constraints.rb
source_commit: 0ecf61a (rowan)
categories: [constraint-vocabulary, json-schema-mapping, polymorphic-fk, conditional-required]
why_included: >
  Constraint vocabulary mapped to JSON Schema: one_of/any_of/when_value/dependent_required (oneOf/anyOf/if-then/dependentRequired). Document-schema-first: JSON Schema's vocabulary is richer than RDBMS, so constraints model here and project to SQL. Worked polymorphic-FK + conditional-requirement examples in header.
---

# frozen_string_literal: true

# rbs_inline: enabled

module Archema
  module ResourceDSL
    # Composition constraints DSL for Resources.
    #
    # Provides JSON Schema-style composition constraints that span multiple
    # attributes. These enable patterns like polymorphic FKs ("exactly one of
    # these must be set") and conditional requirements ("if X then Y required").
    #
    # ## Available Constraints
    #
    # | Constraint | JSON Schema | Purpose |
    # |------------|-------------|---------|
    # | `one_of` | `oneOf` | Exactly one condition must be true |
    # | `any_of` | `anyOf` | At least one condition must be true |
    # | `when_value` | `if/then` | Conditional requirements |
    # | `dependent_required` | `dependentRequired` | If X present, Y required |
    #
    # This implements the document-schema-first philosophy: JSON Schema has
    # richer constraint vocabulary than RDBMS, so we model constraints here
    # and project to SQL where possible.
    #
    # @example Polymorphic FK (exactly one must be set)
    #   class Comment < Archema::Resource
    #     attributes do
    #       uuid_primary_key :id
    #       attribute :body, :string
    #       attribute :post_id, :uuid, :optional
    #       attribute :photo_id, :uuid, :optional
    #       attribute :video_id, :uuid, :optional
    #     end
    #
    #     constraints do
    #       one_of do
    #         present :post_id
    #         present :photo_id
    #         present :video_id
    #       end
    #     end
    #   end
    #
    # @example Conditional requirement
    #   class Order < Archema::Resource
    #     attributes do
    #       attribute :payment_type, :enum, values: [:card, :bank, :crypto]
    #       attribute :card_number, :string, :optional
    #       attribute :bank_account, :string, :optional
    #     end
    #
    #     constraints do
    #       when_value :payment_type, :card do
    #         required :card_number
    #       end
    #
    #       when_value :payment_type, :bank do
    #         required :bank_account
    #       end
    #     end
    #   end
    #
    module Constraints
      # Base class for all constraint definitions
      # @abstract
      class ConstraintDefinition
        # @rbs @message: String?
        attr_reader :message #: String? -- custom error message

        # @rbs message: String? -- custom error message
        # @rbs return: void
        def initialize(message: nil) = @message = message

        # Validate the constraint against attribute values
        #
        # @rbs attributes: Hash[Symbol, untyped] -- the attribute values to validate
        # @rbs return: Array[String] -- error messages (empty if valid)
        def validate(attributes) = raise NotImplementedError, "Subclasses must implement #validate"

        # Export to JSON Schema fragment
        #
        # @rbs return: Hash[String, untyped]
        def to_json_schema = raise NotImplementedError, "Subclasses must implement #to_json_schema"
      end

      # Composition constraint: exactly one sub-constraint must match
      # Maps to JSON Schema `oneOf`
      class OneOfConstraint < ConstraintDefinition
        # @rbs @sub_constraints: Array[Hash[Symbol, untyped]]
        attr_reader :sub_constraints #: Array[Hash[Symbol, untyped]]

        # @rbs sub_constraints: Array[Hash[Symbol, untyped]] -- e.g., [{ present: :post_id }, { present: :photo_id }]
        # @rbs message: String?
        # @rbs return: void
        def initialize(sub_constraints, message: nil)
          super(message: message)
          @sub_constraints = sub_constraints
        end

        # @rbs attributes: Hash[Symbol, untyped]
        # @rbs return: Array[String]
        def validate(attributes)
          matching = @sub_constraints.count { |sc| sub_constraint_matches?(sc, attributes) }

          if matching == 1
            []
          elsif matching.zero?
            [message || default_none_match_message]
          else
            [message || default_multiple_match_message]
          end
        end

        # @rbs return: Hash[String, untyped]
        def to_json_schema = { "oneOf" => @sub_constraints.map { |sc| sub_constraint_to_schema(sc) } }

        private

        # @rbs sc: Hash[Symbol, untyped]
        # @rbs attributes: Hash[Symbol, untyped]
        # @rbs return: bool
        def sub_constraint_matches?(sc, attributes)
          case sc[:type]
          when :present, :required then !attributes[sc[:attribute]].nil?
          when :absent             then attributes[sc[:attribute]].nil?
          when :equals             then attributes[sc[:attribute]] == sc[:value]
          else
            # Unknown constraint type, assume matches
            true
          end
        end

        # @rbs sc: Hash[Symbol, untyped]
        # @rbs return: Hash[String, untyped]
        def sub_constraint_to_schema(sc)
          case sc[:type]
          when :present, :required then { "required" => [sc[:attribute].to_s] }
          when :absent             then { "properties" => { sc[:attribute].to_s => false } }
          when :equals then { "properties" => { sc[:attribute].to_s => { "const" => sc[:value] } }, "required" => [sc[:attribute].to_s] }
          else
            {}
          end
        end

        # @rbs return: String
        def default_none_match_message
          attrs = @sub_constraints.map { |sc| sc[:attribute] }.compact.join(", ")
          "exactly one of #{attrs} must be set"
        end

        # @rbs return: String
        def default_multiple_match_message
          attrs = @sub_constraints.map { |sc| sc[:attribute] }.compact.join(", ")
          "only one of #{attrs} may be set"
        end
      end

      # Composition constraint: at least one sub-constraint must match
      # Maps to JSON Schema `anyOf`
      class AnyOfConstraint < ConstraintDefinition
        # @rbs @sub_constraints: Array[Hash[Symbol, untyped]]
        attr_reader :sub_constraints #: Array[Hash[Symbol, untyped]]

        # @rbs sub_constraints: Array[Hash[Symbol, untyped]]
        # @rbs message: String?
        # @rbs return: void
        def initialize(sub_constraints, message: nil)
          super(message: message)
          @sub_constraints = sub_constraints
        end

        # @rbs attributes: Hash[Symbol, untyped]
        # @rbs return: Array[String]
        def validate(attributes)
          matching = @sub_constraints.any? { |sc| sub_constraint_matches?(sc, attributes) }

          if matching
            []
          else
            [message || default_message]
          end
        end

        # @rbs return: Hash[String, untyped]
        def to_json_schema = { "anyOf" => @sub_constraints.map { |sc| sub_constraint_to_schema(sc) } }

        private

        # Reuse OneOfConstraint's logic
        def sub_constraint_matches?(sc, attributes)
          case sc[:type]
          when :present, :required then !attributes[sc[:attribute]].nil?
          when :absent             then attributes[sc[:attribute]].nil?
          when :equals             then attributes[sc[:attribute]] == sc[:value]
          else
            true
          end
        end

        def sub_constraint_to_schema(sc)
          case sc[:type]
          when :present, :required then { "required" => [sc[:attribute].to_s] }
          when :absent             then { "properties" => { sc[:attribute].to_s => false } }
          when :equals then { "properties" => { sc[:attribute].to_s => { "const" => sc[:value] } }, "required" => [sc[:attribute].to_s] }
          else
            {}
          end
        end

        # @rbs return: String
        def default_message
          attrs = @sub_constraints.map { |sc| sc[:attribute] }.compact.join(", ")
          "at least one of #{attrs} must be set"
        end
      end

      # Conditional constraint: if condition matches, then requirements apply
      # Maps to JSON Schema `if/then/else`
      class ConditionalConstraint < ConstraintDefinition
        # @rbs @condition: Hash[Symbol, untyped]
        # @rbs @then_requirements: Array[Hash[Symbol, untyped]]
        # @rbs @else_requirements: Array[Hash[Symbol, untyped]]
        attr_reader :condition #: Hash[Symbol, untyped]
        attr_reader :then_requirements #: Array[Hash[Symbol, untyped]]
        attr_reader :else_requirements #: Array[Hash[Symbol, untyped]]

        # @rbs condition: Hash[Symbol, untyped] -- e.g., { attribute: :payment_type, equals: :card }
        # @rbs then_requirements: Array[Hash[Symbol, untyped]] -- e.g., [{ required: :card_number }]
        # @rbs else_requirements: Array[Hash[Symbol, untyped]]
        # @rbs message: String?
        # @rbs return: void
        def initialize(condition, then_requirements, else_requirements: [], message: nil)
          super(message: message)
          @condition         = condition
          @then_requirements = then_requirements
          @else_requirements = else_requirements
        end

        # @rbs attributes: Hash[Symbol, untyped]
        # @rbs return: Array[String]
        def validate(attributes)
          errors = []

          if condition_matches?(attributes)
            @then_requirements.each do |req|
              errors.concat(validate_requirement(req, attributes))
            end
          else
            @else_requirements.each do |req|
              errors.concat(validate_requirement(req, attributes))
            end
          end

          errors
        end

        # @rbs return: Hash[String, untyped]
        def to_json_schema
          schema = {
            "if"   => condition_to_schema,
            "then" => requirements_to_schema(@then_requirements)
          }
          schema["else"] = requirements_to_schema(@else_requirements) if @else_requirements.any?
          schema
        end

        private

        # @rbs attributes: Hash[Symbol, untyped]
        # @rbs return: bool
        def condition_matches?(attributes)
          attr_value = attributes[@condition[:attribute]]

          if @condition.key?(:equals)
            attr_value == @condition[:equals]
          elsif @condition.key?(:present)
            !attr_value.nil?
          elsif @condition.key?(:absent)
            attr_value.nil?
          else
            false
          end
        end

        # @rbs req: Hash[Symbol, untyped]
        # @rbs attributes: Hash[Symbol, untyped]
        # @rbs return: Array[String]
        def validate_requirement(req, attributes)
          attr_name  = req[:attribute]
          attr_value = attributes[attr_name]

          case req[:type]
          when :required
            if attr_value.nil?
              [message || "#{attr_name} is required when #{describe_condition}"]
            else
              []
            end
          when :forbidden
            if attr_value.nil?
              []
            else
              [message || "#{attr_name} must not be set when #{describe_condition}"]
            end
          else
            []
          end
        end

        # @rbs return: String
        def describe_condition
          attr = @condition[:attribute]
          if @condition.key?(:equals)
            "#{attr} is #{@condition[:equals]}"
          elsif @condition.key?(:present)
            "#{attr} is present"
          elsif @condition.key?(:absent)
            "#{attr} is absent"
          else
            attr.to_s
          end
        end

        # @rbs return: Hash[String, untyped]
        def condition_to_schema
          attr_name = @condition[:attribute].to_s
          if @condition.key?(:equals)
            {
              "properties" => { attr_name => { "const" => @condition[:equals] } },
              "required"   => [attr_name]
            }
          elsif @condition.key?(:present)
            { "required" => [attr_name] }
          else
            {}
          end
        end

        # @rbs requirements: Array[Hash[Symbol, untyped]]
        # @rbs return: Hash[String, untyped]
        def requirements_to_schema(requirements)
          required = requirements
                     .select { |r| r[:type] == :required }
                     .map { |r| r[:attribute].to_s }

          schema             = {}
          schema["required"] = required if required.any?
          schema
        end
      end

      # Dependent constraint: if attribute is present, other attributes are required
      # Maps to JSON Schema `dependentRequired`
      class DependentRequiredConstraint < ConstraintDefinition
        # @rbs @trigger: Symbol
        # @rbs @requirements: Array[Symbol]
        attr_reader :trigger #: Symbol -- the triggering attribute
        attr_reader :requirements #: Array[Symbol] -- required attributes when trigger is present

        # @rbs trigger: Symbol
        # @rbs requirements: Array[Symbol]
        # @rbs message: String?
        # @rbs return: void
        def initialize(trigger, requirements, message: nil)
          super(message: message)
          @trigger      = trigger
          @requirements = Array(requirements)
        end

        # @rbs attributes: Hash[Symbol, untyped]
        # @rbs return: Array[String]
        def validate(attributes)
          return [] if attributes[@trigger].nil?

          errors = []
          @requirements.each do |req|
            errors << (message || "#{req} is required when #{@trigger} is present") if attributes[req].nil?
          end
          errors
        end

        # @rbs return: Hash[String, untyped]
        def to_json_schema = { "dependentRequired" => { @trigger.to_s => @requirements.map(&:to_s) } }
      end

      # DSL methods added to Resource classes
      module DSL
        # @rbs base: Class
        # @rbs return: void
        def self.included(base) = base.extend(ClassMethods)

        module ClassMethods
          # Get all constraint definitions
          #
          # @rbs return: Array[ConstraintDefinition]
          def constraint_definitions = @constraint_definitions ||= []

          # Define constraints block
          #
          # @rbs &block: ^() -> void
          # @rbs return: void
          def constraints(&)
            context = ConstraintsDSLContext.new(self)
            context.instance_eval(&)
          end

          # Validate all constraints against attribute values
          #
          # @rbs attributes: Hash[Symbol, untyped]
          # @rbs return: Hash[Symbol, Array[String]] -- errors by category
          def validate_constraints(attributes)
            errors = { _constraints: [] }

            constraint_definitions.each do |constraint|
              constraint_errors = constraint.validate(attributes)
              errors[:_constraints].concat(constraint_errors)
            end

            errors.delete(:_constraints) if errors[:_constraints].empty?
            errors
          end

          # Export constraints to JSON Schema
          #
          # @rbs return: Hash[String, untyped]
          def constraints_to_json_schema
            return {} if constraint_definitions.empty?

            # Merge all constraint schemas
            # Note: JSON Schema allows multiple composition keywords at root level
            schema = {}

            constraint_definitions.each do |constraint|
              constraint_schema = constraint.to_json_schema
              schema.merge!(constraint_schema) do |_key, old, new|
                # For arrays like oneOf, anyOf - append
                if old.is_a?(Array) && new.is_a?(Array)
                  old + new
                else
                  new
                end
              end
            end

            schema
          end
        end
      end

      # Context for the constraints DSL block
      class ConstraintsDSLContext
        # @rbs @resource_class: Class
        # @rbs @current_sub_constraints: Array[Hash[Symbol, untyped]]?

        # @rbs resource_class: Class
        # @rbs return: void
        def initialize(resource_class)
          @resource_class          = resource_class
          @current_sub_constraints = nil
        end

        # Define a "one of" constraint (exactly one must match)
        #
        # @example
        #   one_of do
        #     present :post_id
        #     present :photo_id
        #     present :video_id
        #   end
        #
        # @rbs message: String? -- custom error message
        # @rbs &block: ^() -> void
        # @rbs return: void
        def one_of(message: nil, &)
          @current_sub_constraints = []
          instance_eval(&)

          constraint = OneOfConstraint.new(@current_sub_constraints, message: message)
          @resource_class.constraint_definitions << constraint

          @current_sub_constraints = nil
        end

        # Define an "any of" constraint (at least one must match)
        #
        # @example
        #   any_of do
        #     present :email
        #     present :phone
        #   end
        #
        # @rbs message: String? -- custom error message
        # @rbs &block: ^() -> void
        # @rbs return: void
        def any_of(message: nil, &)
          @current_sub_constraints = []
          instance_eval(&)

          constraint = AnyOfConstraint.new(@current_sub_constraints, message: message)
          @resource_class.constraint_definitions << constraint

          @current_sub_constraints = nil
        end

        # Add a "present" sub-constraint (attribute must not be nil)
        #
        # @rbs attribute: Symbol
        # @rbs return: void
        def present(attribute)
          raise "present must be called inside one_of or any_of block" unless @current_sub_constraints

          @current_sub_constraints << { type: :present, attribute: attribute }
        end

        # Add a "required" sub-constraint (alias for present)
        #
        # @rbs attribute: Symbol
        # @rbs return: void
        def required(attribute)
          if @current_sub_constraints
            @current_sub_constraints << { type: :required, attribute: attribute }
          elsif @current_then_requirements
            @current_then_requirements << { type: :required, attribute: attribute }
          else
            raise "required must be called inside one_of, any_of, or when_value block"
          end
        end

        # Add an "absent" sub-constraint (attribute must be nil)
        #
        # @rbs attribute: Symbol
        # @rbs return: void
        def absent(attribute)
          raise "absent must be called inside one_of or any_of block" unless @current_sub_constraints

          @current_sub_constraints << { type: :absent, attribute: attribute }
        end

        # Add an "equals" sub-constraint (attribute must equal value)
        #
        # @rbs attribute: Symbol
        # @rbs value: untyped
        # @rbs return: void
        def equals(attribute, value)
          raise "equals must be called inside one_of or any_of block" unless @current_sub_constraints

          @current_sub_constraints << { type: :equals, attribute: attribute, value: value }
        end

        # Define a conditional constraint
        #
        # @example
        #   when_value :payment_type, :card do
        #     required :card_number
        #   end
        #
        # @rbs attribute: Symbol
        # @rbs value: untyped
        # @rbs message: String?
        # @rbs &block: ^() -> void
        # @rbs return: void
        def when_value(attribute, value, message: nil, &)
          @current_then_requirements = []
          instance_eval(&)

          condition  = { attribute: attribute, equals: value }
          constraint = ConditionalConstraint.new(
            condition,
            @current_then_requirements,
            message: message
          )
          @resource_class.constraint_definitions << constraint

          @current_then_requirements = nil
        end

        # Define a dependent required constraint
        #
        # @example
        #   dependent_required :email_verified, requires: [:email]
        #
        # @rbs trigger: Symbol
        # @rbs requires: Array[Symbol]
        # @rbs message: String?
        # @rbs return: void
        def dependent_required(trigger, requires:, message: nil)
          constraint = DependentRequiredConstraint.new(trigger, requires, message: message)
          @resource_class.constraint_definitions << constraint
        end
      end
    end
  end
end
