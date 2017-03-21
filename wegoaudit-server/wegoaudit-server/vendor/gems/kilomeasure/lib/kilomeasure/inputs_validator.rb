module Kilomeasure
  class InputsValidator < ObjectBase
    fattrs :inputs,
           :measure

    boolean_attr_accessor :strict

    attr_reader :errors

    def self.validate(**options)
      validator = new(options)
      validator.validate
      validator.errors
    end

    def initialize(*)
      super
      @errors = {}
    end

    def ensure_no_unknown_inputs
      inputs.each do |key, _value|
        next if expected_input_names.include?(key)
        next if key =~ /_proposed$|_existing$/

        @errors[key] ||= []
        @errors[key] << "Unknown input #{key}"
      end
    end

    def ensure_no_unused_inputs
      return if measure.inputs_only?

      measure.input_names.each do |key, _value|
        next if measure.dependencies.find do |value|
          value.to_s.gsub(/_proposed|_existing$/, '') == key.to_s
        end
        next if %w[utility_rebate quantity].include?(key.to_s)

        @errors[key] ||= []
        @errors[key] << "Unused input #{key}"
      end
    end

    def expected_input_names
      ((measure.input_names | CALCULATION_CONSTANTS.keys) +
       [:proposed, :quantity, :cost_of_measure])
    end
    memoize :expected_input_names

    def validate
      ensure_no_unknown_inputs if strict
      # ensure_no_unused_inputs
      validate_field_options
    end

    def validate_field_options
      measure.field_definitions.each do |field, options|
        field_options = options.fetch(:options, {})
        next if field_options.empty?
        next unless inputs.has_key?(field)

        value = inputs[field]
        next if field_options.include?(value)

        @errors[field] ||= []
        @errors[field] << "Invalid option #{value} for #{field}"
      end
    end
  end
end
