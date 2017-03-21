module LiquidTags
  class PageBreak < Liquid::Tag
    def render(_context)
      <<-HTML
      <hr class='hide-from-pdf'>
      <div class='page-break'></div>
      HTML
    end
  end
end
