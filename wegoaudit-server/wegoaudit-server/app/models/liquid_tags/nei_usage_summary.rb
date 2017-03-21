module LiquidTags
  class NeiUsageSummary < Liquid::Tag
    include ActionView::Helpers::NumberHelper
    include Memoizer # rubocop:disable Wego/ImplicitMemoizer

    attr_reader :audit_report,
                :audit_report_calculator

    ENERGY_FIELDS = [
      :annual_energy_usage_existing,
      :annual_energy_savings,
      :annual_gas_savings,
      :annual_gas_usage_existing,
      :annual_oil_savings,
      :annual_oil_usage_existing,
      :annual_electric_savings,
      :annual_electric_usage_existing
    ]

    TEMPLATE = <<-ERB.strip_heredoc
      <table>
        <thead>
          <tr>
            <th></th>
            <th>Current Consumption</th>
            <th>Projected Savings</th>
            <th>% Savings Against Total</th>
          </tr>
        </thead>

        <tbody>
          <tr>
            <td><strong>Total Water (gallons)</strong></td>
            <td><%= summary[:annual_water_usage_existing] %></td>
            <td><%= summary[:annual_water_savings] %></td>
            <td><%= percentage_reduction[:water] %></td>
          </tr>
          <tr>
            <td><strong>Total Energy (million Btus)</strong></td>
            <td><%= summary[:annual_energy_usage_existing] %></td>
            <td><%= summary[:annual_energy_savings] %></td>
            <td><%= percentage_reduction[:energy] %></td>
          </tr>
          <tr>
            <td>Electricity</td>
            <td><%= summary[:annual_electric_usage_existing] %></td>
            <td><%= summary[:annual_electric_savings] %></td>
            <td><%= percentage_reduction[:electric] %></td>
          </tr>
          <tr>
            <td>Natural Gas</td>
            <td><%= summary[:annual_gas_usage_existing] %></td>
            <td><%= summary[:annual_gas_savings] %></td>
            <td><%= percentage_reduction[:gas] %></td>
          </tr>
          <tr>
            <td>Heating Oil</td>
            <td><%= summary[:annual_oil_usage_existing] %></td>
            <td><%= summary[:annual_oil_savings] %></td>
            <td><%= percentage_reduction[:oil] %></td>
          </tr>
        </tbody>
      </table>
    ERB

    def render(context)
      @audit_report = context.registers[:audit_report]
      @audit_report_calculator = context.registers[:audit_report_calculator]
      ERB.new(TEMPLATE).result(binding)
    end

    private

    def calculations
      energy_calculations.merge(water_calculations)
    end
    memoize :calculations

    def energy_calculations
      ENERGY_FIELDS.each_with_object({}) do |field, hash|
        value = audit_report_calculator.summary[field]
        if value.is_a?(Numeric)
          if [:annual_gas_usage_existing, :annual_gas_savings].include?(field)
            value = value.to_f * Retrocalc::THERMS_TO_BTU_COEFFICIENT
          elsif [:annual_electric_usage_existing,
                 :annual_electric_savings].include?(field)
            value = value.to_f * Retrocalc::KWH_TO_BTU_COEFFICIENT
          end
          value /= 1_000_000.0
          hash[field] = value
        end
      end
    end

    def percentage_reduction
      [:energy, :water, :electric, :gas, :oil]
        .each_with_object({}) do |data_type, hash|
        if data_type == :water
          total_value =
            audit_report_calculator.summary[:annual_water_usage_existing]
          savings =
            audit_report_calculator.summary[:annual_water_savings]
        else
          total_value = calculations[:annual_energy_usage_existing]
          savings = calculations["annual_#{data_type}_savings".to_sym]
        end

        unless total_value.is_a?(Numeric) && savings.is_a?(Numeric)
          hash[data_type] = '&mdash;'
          next
        end

        value = (savings / total_value) * 100
        value = number_with_precision(value, precision: 2)
        value = "#{value}%"
        hash[data_type] = value
      end
    end
    memoize :percentage_reduction

    def precision_for(value)
      [0, 2 - Math.log10([value, 0.01].max).floor].max
    end

    def summary
      calculations.each_with_object({}) do |(field, value), hash|
        if value.is_a?(Numeric)
          value = number_with_precision(
            value,
            precision: precision_for(value),
            delimiter: ',')
        else
          value = '&mdash;'
        end
        hash[field] = value
      end
    end
    memoize :summary

    def water_calculations
      hash = {}
      [:annual_water_usage_existing, :annual_water_savings].each do |field|
        hash[field] = audit_report_calculator.summary[field]
      end
      hash
    end
  end
end
