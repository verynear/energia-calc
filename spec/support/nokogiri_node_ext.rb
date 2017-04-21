module Ext
  module Nokogiri
    module XML
      module Node
        def nice_inner_text_for_input
          case attributes['type'].value
          when 'text', 'submit'
            attributes['value'].try(:value)
          when 'checkbox'
            attributes['checked'].try(:value).present? ? 'X' : '_'
          when 'image'
            attributes['alt'].try(:value)
          end
        end

        def nice_inner_text_including_inputs
          txt =
            if children.present?
              children.map(&:nice_inner_text_including_inputs).join(' ')
            elsif name == 'input'
              ":#{nice_inner_text_for_input}:" if nice_inner_text_for_input
            elsif name == 'img'
              attributes['alt']
            else
              inner_text
            end

          txt.squish if txt.is_a?(String)
        end
      end
    end
  end
end

module Nokogiri
  module XML
    class Node
      include Ext::Nokogiri::XML::Node
    end
  end
end
