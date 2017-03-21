module Kilomeasure
  class Measure < ObjectBase
    fattrs :data_types,
           :field_definitions,
           :formulas,
           :inputs,
           :lookups,
           :name,
           :output_formulas,
           :outputs,
           :defaults

    boolean_attr_accessor :inputs_only

    def initialize(**options)
      options = options.clone
      self.defaults = options.delete(:defaults) { {} }
      self.lookups = options.delete(:lookups) { {} }
      super
      self.inputs ||= []
      self.data_types ||= []
      self.field_definitions ||= {}
      self.inputs_only = false if @inputs_only.nil?
      defaults.deep_symbolize_keys!
      @error = []
    end

    def dependencies
      formulas.dependencies + output_formulas.dependencies
    end

    def for_water?
      data_types.include?('water')
    end

    def for_electric?
      data_types.include?('electric')
    end

    def for_gas?
      data_types.include?('gas')
    end

    def for_oil?
      data_types.include?('oil')
    end

    def for_water_heating?
      data_types.include?('water_heating')
    end

    def for_building_heating?
      data_types.include?('heating')
    end

    def input_names
      inputs.map(&:name)
    end
    memoize :input_names

    def main_formula_names
      array = [
        :annual_operating_cost,
        :retrofit_cost
      ]

      [:annual_water_usage,
       :annual_electric_usage,
       :annual_gas_usage,
       :annual_oil_usage].each do |formula_name|
         data_type = /annual_(.+)_usage/.match(formula_name)[1]
         array << formula_name if data_types.include?(data_type)
       end

      array
    end

    def run_calculations(inputs: {})
      BulkCalculationsRunner.run(
        measure: self,
        formulas: formulas,
        inputs: inputs)
    end

    # Run comparative formulas like annual_cost_savings where calculations
    # for proposed values can depend on the existing values
    #
    def run_retrofit_calculations(**options)
      RetrofitCalculationsRunner.run(
        measure: self,
        **options)
    end
  end
end
