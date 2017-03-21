module LiquidTags
  class MeasuresList < Liquid::Tag
    attr_reader :audit_report

    def render(context)
      @audit_report = context.registers[:audit_report]
      ERB.new(erb_template).result(binding)
    end

    private

    def enabled_selections
      audit_report.measure_selections.where(enabled: true)
    end

    def erb_template
      <<-HTML.strip_heredoc
        <% enabled_selections.each do |selection| %>
          <%= title_html_for(selection) %>
          <%= photo_html_for(selection) %>
        <% end %>
      HTML
    end

    def photo_html_for(measure_selection)
      if measure_selection.wegoaudit_photo_id.present?
        url = photo_url_for(measure_selection)
        "<img src=#{url}>"
      else
        'No image selected'
      end
    end

    def photo_url_for(measure_selection)
      serializer = MeasureSelectionSerializer.new(
        measure_selection: measure_selection)
      photo_options = serializer.photos_as_json

      selected_photo = photo_options.find do |photo|
        photo['id'] == measure_selection.wegoaudit_photo_id
      end
      selected_photo['thumb_url']
    end

    def title_html_for(measure_selection)
      "<strong>#{measure_selection.measure_name}</strong>"
    end
  end
end
