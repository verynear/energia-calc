module LiquidTags
  class DetailedRecommendationsList < Liquid::Tag
    attr_reader :audit_report,
                :audit_report_calculator

    include ActionView::Helpers::NumberHelper
    include Memoizer # rubocop:disable Wego/ImplicitMemoizer

    def render(context)
      @audit_report = context.registers[:audit_report]
      @audit_report_calculator = context.registers[:audit_report_calculator]
      ERB.new(erb_template).result(binding)
    end

    private

    def data_type_labels
      {
        water: 'Water',
        electric: 'Electricity',
        gas: 'Natural Gas',
        oil: 'Heating Oil'
      }
    end

    def erb_template
      <<-HTML.strip_heredoc
      <% sorted_summaries.each do |summary| %>
        <div>
          <div><strong><%= summary[:name] %></strong></div>
          <div>Existing Condition: <%= summary[:description] %></div>
          <div>Recommendation: <%= summary[:recommendation] %></div>
          <table>
            <% summary[:data_types].each do |data_type| %>
              <tr>
                <td><%= data_type_labels[data_type] %> Savings</td>
                <td><%= summary["annual_\#\{data_type\}_savings".to_sym] %></td>
              </tr>
            <% end %>
            <tr>
              <td>Cost Savings</td>
              <td><%= summary[:annual_cost_savings] %></td>
            </tr>
            <tr>
              <td>Est. Upfront Cost</td>
              <td><%= summary[:cost_of_measure] %></td>
            </tr>
            <tr>
              <td>Est. Incentive</td>
              <td><%= summary[:utility_rebate] %></td>
            </tr>
          </table>
        </div>
      <% end %>
      HTML
    end

    def measure_selections
      audit_report
        .measure_selections
        .where(enabled: true)
    end
    memoize :measure_selections

    def sorted_summaries
      summaries.sort_by { |summary| summary[:savings_investment_ratio] }
    end

    def summaries
      measure_selections.map do |measure_selection|
        summary =
          audit_report_calculator.summary_for_measure_selection(measure_selection)
          .to_h

        fields = [
          :annual_cost_savings,
          :annual_electric_savings,
          :annual_gas_savings,
          :annual_oil_savings,
          :annual_water_savings,
          :cost_of_measure,
          :utility_rebate,
          :savings_investment_ratio
        ]

        summary = summary.each_with_object({}) do |(field, value), hash|
          next unless fields.include?(field)

          if value.is_a?(Numeric)
            value = number_to_currency(value)
          else
            value = '&mdash;'
          end

          hash[field] = value
        end

        summary[:name] = measure_selection.calc_measure_name
        description = if measure_selection.description.present?
                        measure_selection.description
                      else
                        '<strong>[DESCRIPTION]</strong>'
                      end
        recommendation =
          if measure_selection.recommendation.present?
            measure_selection.recommendation
          else
            '<strong>[RECOMMENDATION]</strong>'
          end
        summary[:description] = description
        summary[:recommendation] = recommendation
        summary[:data_types] = measure_selection.data_types
        summary
      end
    end
  end
end
