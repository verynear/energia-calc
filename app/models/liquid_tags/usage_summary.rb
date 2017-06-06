module LiquidTags
  class UsageSummary < Liquid::Tag
    include ActionView::Helpers::NumberHelper
    include Memoizer # rubocop:disable Wego/ImplicitMemoizer

    attr_reader :audit_report,
                :audit_report_calculator,
                :data_types

    HEADERS = {
      'water' => 'Water',
      'electric' => 'Electric',
      'gas' => 'Natural Gas',
      'oil' => 'Heating Oil'
    }

    INPUTS = [
      :annual_energy_usage_existing,
      :annual_energy_savings,
      :annual_gas_savings,
      :annual_gas_usage_existing,
      :annual_oil_savings,
      :annual_oil_usage_existing,
      :annual_electric_savings,
      :annual_electric_usage_existing
    ]

    FIELDS = [
      :annual_operating_cost_existing,
      :annual_cost_savings,
      :annual_operating_cost_proposed,
      :annual_cost_reduction_percentage
    ]

    TEMPLATE = <<-ERB.strip_heredoc
      <table>
        <thead>
          <tr>
            <th></th>
            <th><%= info[:header] %></th>
          </tr>
        </thead>

        <tbody>
          <tr>
            <td>Current average utility cost</td>
            <td><%= info[:annual_operating_cost_existing] %></td>
          </tr>
          <tr>
            <td>Projected average savings</td>
            <td><%= info[:annual_cost_savings] %></td>
          </tr>
          <tr>
            <td>Projected average utility cost</td>
            <td><%= info[:annual_operating_cost_proposed] %></td>
          </tr>
          <tr>
            <td><strong>Projected reduction</strong></td>
            <td><%= info[:annual_cost_reduction_percentage] %></td>
          </tr>
        </tbody>
      </table>
    ERB

    def initialize(tag_name, arguments, tokens)
      @data_types = arguments.split(',').map(&:strip)
      super
    end

    def render(context)
      @audit_report = context.registers[:audit_report]
      @audit_report_calculator = context.registers[:audit_report_calculator]
      ERB.new(TEMPLATE).result(binding)
    end

    private

    def info
      INPUTS.each_with_object({}) do |field, hash|
        value = audit_report_calculator.summary[field]

        if field == :annual_cost_reduction_percentage
          if value.is_a?(Numeric)
            value = "#{value.round(2)}%"
          else
            value = '&mdash;'
          end
        else
          if value.is_a?(Numeric)
            value = "#{number_to_currency(value)}/year"
          else
            value = 'N/A'
          end
        end
        hash[field] = value
      end
    end

    def precision_for(value)
      [0, 2 - Math.log10([value, 0.01].max).floor].max
    end
  end
end
