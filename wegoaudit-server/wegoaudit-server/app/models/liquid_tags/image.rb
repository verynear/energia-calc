module LiquidTags
  class Image < Liquid::Tag
    include ActionView::Helpers::AssetTagHelper

    def initialize(tag_name, image_url, tokens)
      @image_url = image_url.rstrip
      super
    end

    def render(context)
      if context.registers[:for_pdf]
        image_tag(
          "file:///#{WickedPdfHelper.root_path.join('public', 'images', @image_url)}"
        )
      else
        image_tag(@image_url)
      end
    end
  end
end
