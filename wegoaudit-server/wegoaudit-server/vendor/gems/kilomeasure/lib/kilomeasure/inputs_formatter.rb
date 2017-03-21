module Kilomeasure
  class InputsFormatter < ObjectBase
    fattrs :inputs,
           :measure

    boolean_attr_accessor :strict
    boolean_attr_accessor :add_defaults

    def initialize(*)
      super
      raise ArgumentError, :inputs unless inputs
      raise ArgumentError, :measure unless measure
      @inputs = @inputs.clone
      @inputs.symbolize_keys!
      self.add_defaults = true if @add_defaults.nil?
      self.strict = false if @strict.nil?
      clean_inputs
      modify_inputs
    end

    private

    def add_constant_inputs
      inputs.merge!(CALCULATION_CONSTANTS)
    end

    def add_default_inputs
      measure.defaults.each do |key, value|
        if value.is_a?(Hash)
          default = inputs[:proposed] ? value[:proposed] : value[:existing]
          inputs[key] ||= default
        else
          inputs[key] ||= value
        end
      end
    end

    def clean_inputs
      inputs.delete_if { |_, v| [nil, ''].include?(v) }
    end

    def modify_inputs
      add_default_inputs if add_defaults?
      add_constant_inputs
    end
  end
end
