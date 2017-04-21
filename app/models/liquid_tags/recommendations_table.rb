module LiquidTags
  class RecommendationsTable < Liquid::Tag
    attr_reader :audit_report,
                :audit_report_calculator

    include Memoizer # rubocop:disable Wego/ImplicitMemoizer

    CALCULATION_TITLES = {
      description: 'Recommendation',
      cost_of_measure: 'Estimated Cost',
      annual_cost_savings: 'Annual Dollar Savings',
      annual_usage_savings: 'Annual Usage Reduction',
      years_to_payback: 'Years to Payback',
      retrofit_lifetime: 'Upgrade Lifetime (Years)',
      savings_investment_ratio: 'SIR',
      utility_rebate: 'Potential Utility Rebate'
    }

    def render(context)
      @audit_report = context.registers[:audit_report]
      @audit_report_calculator = context.registers[:audit_report_calculator]
      ERB.new(erb_template).result(binding)
    end

    private

    def data_for(measure_selection)
      measure_summary =
        audit_report_calculator.summary_for_measure_selection(measure_selection)
      serializer = MeasureSummarySerializer.new(
        measure_summary: measure_summary)
      serializer.summary
    end

    def description_cell(measure_selection, index)
      text = "#{index + 1}. <strong>#{measure_selection.measure_name}"
      if measure_selection.description.present?
        text += ":</strong> #{measure_selection.description}"
      else
        text += '</strong>'
      end
      text
    end

    def enabled_selections
      audit_report.measure_selections.where(enabled: true)
    end
    memoize :enabled_selections

    def energy_columns
      enabled_selections.flat_map(&:relevant_energy_calculations).uniq
    end
    memoize :energy_columns

    def erb_template
      <<-HTML.strip_heredoc
      <table class="table table--recommendations">
        <colgroup>
          <% headers.each do |header| %>
            <col class="table--recommendations__<%= header %>">
          <% end %>
        </colgroup>
        <thead>
          <%= header_row %>
        </thead>
        <tbody>
          <% rows.each do |row| %>
            <%= row %>
          <% end %>
        </body>
      </table>
      HTML
    end

    def header_mapping
      ([
        :description,
        :cost_of_measure,
        :annual_cost_savings,
        :annual_usage_savings,
        :years_to_payback,
        :retrofit_lifetime,
        :savings_investment_ratio,
        :utility_rebate
      ]).map { |header| [CALCULATION_TITLES[header], header] }
    end

    def header_row
      '<tr>' + headers.map { |header| "<th>#{header}</th>" }.join('') + '</tr>'
    end

    def headers
      header_mapping.map(&:first)
    end

    def measure_tr(measure_selection, index)
      text = '<tr>'
      summary = data_for(measure_selection)
      header_mapping.each_with_index.map do |(_header, key), column_index|
        if column_index == 0
          value = description_cell(measure_selection, index)
        elsif key == :annual_usage_savings
          value = energy_columns.map do |column_key|
            summary[column_key]
          end.join('<br>')
        else
          value = summary[key]
        end
        text += "<td>#{value}</td>"
      end
      text + '</tr>'
    end

    def rows
      enabled_selections.rank(:calculate_order).each_with_index
        .map do |measure_selection, index|
        measure_tr(measure_selection, index)
      end
    end
  end
end
