module Kilomeasure
  # Calculates a single expression against provided inputs
  #
  class Formula < ObjectBase
    attr_accessor :additional_dependencies,
                  :expression,
                  :name

    attr_reader :value

    def initialize(*)
      super
      self.additional_dependencies ||= []
    end

    def dependencies
      evaluator.dependencies(expression).map(&:to_sym) +
        additional_dependencies
    end
    memoize :dependencies

    def run(inputs = {})
      inputs = inputs.symbolize_keys
      unless missing_inputs(inputs).empty?
        raise ArgumentError, "Missing required inputs #{missing_inputs(inputs)}"
      end

      @value = evaluator.evaluate!(expression, inputs)
    end

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

    def missing_inputs(inputs)
      (dependencies - inputs.keys)
    end
  end
end
