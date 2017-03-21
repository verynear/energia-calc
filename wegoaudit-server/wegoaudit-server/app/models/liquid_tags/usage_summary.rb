module LiquidTags
  class UsageSummary < Liquid::Tag
    include ActionView::Helpers::NumberHelper

    attr_reader :audit_report,
                :audit_report_calculator,
                :data_types

    HEADERS = {
      'water' => 'Water',
      'electric' => 'Electric',
      'gas' => 'Natural Gas',
      'oil' => 'Heating Oil'
    }

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
            <% data_types.each do |data_type| %>
            <th><%= info[data_type.to_sym][:header] %></th>
            <% end %>
          </tr>
        </thead>

        <tbody>
          <tr>
            <td>Current average utility cost</td>
            <% data_types.each do |data_type| %>
            <td><%= info[data_type.to_sym][:annual_operating_cost_existing] %></td>
            <% end %>
          </tr>
          <tr>
            <td>Projected average savings</td>
            <% data_types.each do |data_type| %>
            <td><%= info[data_type.to_sym][:annual_cost_savings] %></td>
            <% end %>
          </tr>
          <tr>
            <td>Projected average utility cost</td>
            <% data_types.each do |data_type| %>
            <td><%= info[data_type.to_sym][:annual_operating_cost_proposed] %></td>
            <% end %>
          </tr>
          <tr>
            <td><strong>Projected reduction</strong></td>
            <% data_types.each do |data_type| %>
            <td><%= info[data_type.to_sym][:annual_cost_reduction_percentage] %></td>
            <% end %>
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
      data_types.each_with_object({}) do |data_type, hash|
        hash[data_type] ||= {}
        hash[data_type][:header] = HEADERS[data_type]
        FIELDS.each do |field|
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
          hash[data_type][field] = value
        end
      end
    end

    def precision_for(value)
      [0, 2 - Math.log10([value, 0.01].max).floor].max
    end
  end
end
