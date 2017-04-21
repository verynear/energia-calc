module Calculations
  class AnnualEnergyUsageExisting < Generic::Strict
    attr_accessor :audit_report

    delegate :annual_electric_usage_existing,
             :annual_gas_usage_existing,
             :annual_oil_usage_existing,
             to: :audit_report

    def call
      return unless annual_electric_usage_existing ||
        annual_gas_usage_existing ||
        annual_oil_usage_existing

      electric_usage_in_btu = annual_electric_usage_existing.to_f * 3412.14163312794

      gas_usage_in_btu = annual_gas_usage_existing.to_f * 100000

      oil_usage_in_btu = annual_oil_usage_existing.to_f

      electric_usage_in_btu +
        gas_usage_in_btu +
        oil_usage_in_btu
    end
  end
end
