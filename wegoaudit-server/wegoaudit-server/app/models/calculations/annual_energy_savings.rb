module Calculations
  class AnnualEnergySavings < Generic::Strict
    attr_accessor :calculator

    delegate :annual_electric_savings,
             :annual_gas_savings,
             :annual_oil_savings,
             to: :calculator

    def call
      return unless annual_electric_savings ||
        annual_gas_savings ||
        annual_oil_savings

      electric_savings = annual_electric_savings.to_f * Retrocalc::KWH_TO_BTU_COEFFICIENT

      gas_savings = annual_gas_savings.to_f * Retrocalc::THERMS_TO_BTU_COEFFICIENT

      oil_savings = annual_oil_savings.to_f

      electric_savings + gas_savings + oil_savings
    end
  end
end
