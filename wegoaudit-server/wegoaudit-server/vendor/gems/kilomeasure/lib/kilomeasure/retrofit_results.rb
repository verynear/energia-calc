module Kilomeasure
  class RetrofitResults < ObjectBase
    fattrs  :after_calculations_set,
            :before_calculations_set,
            :overall_calculations_set,
            :measure

    def results
      overall_calculations_set.results
    end

    def errors_hash
      overall_calculations_set.errors_hash
    end

    def before_results
      before_calculations_set.results
    end

    def after_results
      after_calculations_set.results
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

    def [](formula_name)
      get_calculation_value(formula_name)
    end
  end
end
