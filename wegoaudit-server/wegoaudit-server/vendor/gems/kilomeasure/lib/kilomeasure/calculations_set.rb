module Kilomeasure
  class CalculationsSet < ObjectBase
    fattrs :measure,
           :errors_hash,
           :inputs,
           :results

    delegate :keys, to: :results

    def initialize(*)
      super
      self.errors_hash ||= {}
      self.results ||= {}
      self.inputs ||= {}
    end

    def [](formula_name)
      get_calculation_value(formula_name)
    end

    def apply_quantity(quantity)
      measure.main_formula_names.each do |field|
        next unless results[field].is_a?(Numeric)
        results[field] *= quantity.to_i
      end
    end

    def get_calculation(formula_name)
      Calculation.new(
        name: formula_name,
        measure: measure,
        result: results[formula_name],
        errors: errors_hash[formula_name])
    end

    def get_calculation_value(formula_name)
      get_calculation(formula_name).value
    end

    def merge(options)
      self.class.new(measure: measure,
                     errors_hash: errors_hash,
                     results: results.merge(options)
         )
    end
  end
end
