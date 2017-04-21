module Kilomeasure
  class BulkCalculationsRunner < ObjectBase
    fattrs :inputs,
           :measure,
           :formulas

    boolean_attr_accessor :strict

    def self.run(**options)
      new(options).results
    end

    def initialize(*)
      super
      raise ArgumentError, :inputs unless inputs
      raise ArgumentError, :formulas unless formulas
    end

    def results
      evaluator.store(inputs)
      expressions_hash = formulas.each_with_object({}) do |formula, hash|
        next if inputs.keys.include?(formula.name)

        hash[formula.name] = formula.expression
      end

      errors_hash = {}

      results_hash = evaluator.solve(expressions_hash) do |error, name|
        if error.is_a?(Dentaku::UnboundVariableError)
          errors_hash[name] = error.unbound_variables.map(&:to_sym)
        elsif error.is_a?(ZeroDivisionError)
          errors_hash[name] = [:infinite]
        end
        nil
      end

      results_hash.each do |key, value|
        next unless value.is_a?(String)

        results_hash[key] = nil
        errors_hash[key] = [:unresolved]
      end

      errors_hash.symbolize_keys!

      CalculationsSet.new(
        results: results_hash,
        errors_hash: errors_hash,
        measure: measure,
        inputs: inputs)
    end
    memoize :results

    private

    def evaluator
      Dentaku::Calculator.new.tap do |evaluator|
        evaluator.add_function(
          :pow,
          :numeric,
          ->(mantissa, exponent) { mantissa**exponent }
        )
      end
    end
    memoize :evaluator
  end
end
