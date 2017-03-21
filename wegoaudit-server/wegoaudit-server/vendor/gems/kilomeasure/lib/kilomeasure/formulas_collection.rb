# A collection of formulas
#
module Kilomeasure
  class FormulasCollection < Array
    def initialize(*)
      super
      formulas_lookup
      freeze
    end

    def dependencies
      flat_map(&:dependencies).uniq
    end

    def get_by_name(formula_name)
      formulas_lookup[formula_name]
    end

    private

    def formulas_lookup
      @formulas_lookup ||= reduce({}) do |hash, formula|
        hash[formula.name] = formula
        hash
      end.with_indifferent_access
    end
  end
end
