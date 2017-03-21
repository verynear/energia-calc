module Calculations
  class SavingsInvestmentRatio < Generic::Strict
    attr_accessor :audit_report,
                  :calculator

    delegate :escalation_rate,
             :inflation_rate,
             :interest_rate,
             to: :audit_report

    delegate :annual_maintenance_cost_savings,
             :degradation_rate,
             :retrofit_lifetime,
             :annual_cost_savings,
             :cost_of_measure,
             to: :calculator

    def call
      return unless retrofit_lifetime && annual_cost_savings && cost_of_measure

      return :infinity if cost_of_measure == 0

      (lifetime_savings / cost_of_measure).round(4)
    end

    def npv
      lifetime_savings - cost_of_measure
    end

    private

    def get_alpha_value(r_value)
      if r_value == 1
        retrofit_lifetime
      else
        (1 - (r_value**retrofit_lifetime)) /
          (1 - r_value) * r_value
      end
    end

    def lifetime_savings
      inflation_percentage = (inflation_rate.to_f / 100.0)
      interest_percentage = (interest_rate.to_f / 100.0)
      degradation_percentage = (degradation_rate.to_f / 100.0)
      escalation_percentage = (escalation_rate.to_f / 100.0)

      discount_percentage = interest_percentage - inflation_percentage
      real_escalation_percentage =
        escalation_percentage - inflation_percentage

      r_value =
        ((1.0 + real_escalation_percentage) / (1.0 + discount_percentage)) *
        (1.0 - degradation_percentage)
      alpha_value = get_alpha_value(r_value)
      alpha_value * (annual_cost_savings + annual_maintenance_cost_savings.to_f)
    end
  end
end
