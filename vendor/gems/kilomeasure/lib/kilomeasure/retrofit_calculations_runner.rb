module Kilomeasure
  # Runs retrofit calculations, which require taking a set of before
  # calculations and a set of after calculations and calculating total savings
  # from the difference. This can be more complicated than simply subtracting
  # the after value from the before value, because proposed calculations may
  # reference intermediate values from the existing calculations.
  #
  class RetrofitCalculationsRunner < ObjectBase
    fattrs :after_inputs,
           :before_inputs,
           :shared_inputs,
           :errors_hash,
           :measure

    boolean_attr_accessor :strict

    def self.run(**options)
      new(options).run
    end

    def initialize(*)
      super
      raise ArgumentError, 'missing measure' unless measure
      raise ArgumentError, 'missing before_inputs'  unless before_inputs
      raise ArgumentError, 'missing after_inputs' unless after_inputs
      self.before_inputs = @before_inputs.clone
      self.after_inputs = @after_inputs.clone
      self.shared_inputs ||= {}
      self.shared_inputs = @shared_inputs.clone
      self.strict = false if @strict.nil?

      before_inputs[:proposed] = false
      after_inputs[:proposed] = true
      unless measure.inputs_only?
        self.before_inputs = format_inputs(before_inputs)
      end

      self.after_inputs = format_inputs(after_inputs)
      self.shared_inputs = format_inputs(shared_inputs, add_defaults: false)
    end

    def run
      if validation_errors.any?
        return CalculationsSet.new(errors_hash: validation_errors)
      end

      before_calculations_set = run_before_calculations
      after_calculations_set = run_after_calculations(before_calculations_set)

      before_after_inputs =
        build_before_after_inputs(
          before_calculations_set,
          after_calculations_set)

      overall_calculations_set = run_calculations(
        inputs: before_after_inputs,
        formulas: measure.output_formulas)

      RetrofitResults.new(
        measure: measure,
        after_calculations_set: after_calculations_set,
        before_calculations_set: before_calculations_set,
        overall_calculations_set: overall_calculations_set
      )
    end

    private

    def build_before_after_inputs(before_calculations_set, after_calculations_set)
      before_after_inputs = {}
      before_after_inputs.merge!(after_inputs)
      before_after_inputs.merge!(shared_inputs)

      [[before_calculations_set, :existing],
       [after_calculations_set, :proposed]]
        .each do |calculations_set, descriptor|
          calculations_set.results.each do |key, value|
            if key =~ /(_existing|_proposed)$/
              new_field_name = key
            else
              new_field_name = "#{key}_#{descriptor}"
            end
            before_after_inputs[new_field_name] = value
          end
        end

      before_after_inputs.symbolize_keys!
      before_after_inputs
    end

    def format_inputs(inputs, **options)
      InputsFormatter.new(inputs: inputs, measure: measure, **options).inputs
    end

    def run_after_calculations(before_calculations_set)
      inputs = after_inputs.clone
      inputs[:quantity] ||= 1

      before_inputs.each do |key, value|
        inputs["#{key}_existing".to_sym] = value
      end
      after_inputs.each do |key, value|
        inputs["#{key}_proposed".to_sym] = value
      end

      # Make before input results available to the after input calculations
      before_calculations_set.results.each do |key, value|
        inputs["#{key}_existing".to_sym] = value
      end

      inputs.merge!(shared_inputs)

      calculations_set = run_calculations(
        inputs: inputs,
        formulas: measure.formulas)
      calculations_set.apply_quantity(inputs[:quantity].to_i)
      calculations_set
    end

    def run_before_calculations
      inputs = before_inputs.clone
      inputs[:quantity] ||= 1

      before_inputs.each do |key, value|
        inputs["#{key}_existing".to_sym] = value
      end

      inputs.merge!(shared_inputs)

      calculations_set = run_calculations(
        inputs: inputs,
        formulas: measure.formulas)
      calculations_set.apply_quantity(inputs[:quantity].to_i)
      calculations_set
    end

    def run_calculations(inputs: {}, formulas:)
      Kilomeasure::BulkCalculationsRunner.run(
        measure: measure,
        formulas: formulas,
        strict: strict,
        inputs: inputs)
    end

    def validation_errors
      validation_errors = {}
      unless measure.inputs_only?
        validation_errors.merge(validate_inputs(before_inputs))
      end
      validation_errors.merge(validate_inputs(after_inputs))
      validation_errors.merge(validate_inputs(shared_inputs))
      validation_errors
    end

    def validate_inputs(inputs)
      InputsValidator.validate(
        inputs: inputs,
        strict: strict,
        measure: measure)
    end
  end
end
