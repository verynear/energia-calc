module LiquidTags
  class ContentBlock < Liquid::Tag
    def initialize(tag_name, block_name, tokens)
      @block_name = block_name.rstrip
      super
    end

    def render(context)
      @context = context

      if mode == 'blank'
        blank_textarea
      elsif mode == 'active'
        active_textarea
      else
        rendered_markdown
      end
    end

    private

    def active_textarea
      <<-EOS.strip_heredoc
        <label for='content_block[#{@block_name}]'>
        #{@block_name}
        </label>
        <textarea
          class='markdown-editor__contentblock js-contentblock-textarea'
          data-contentblock-name='#{@block_name}'
          name='content_block[#{@block_name}]'>
        #{markdown}
        </textarea>
      EOS
    end

    def audit_report_id
      @context.registers[:audit_report].id
    end

    def blank_textarea
      <<-EOS.strip_heredoc
        <textarea
          class='markdown-editor__contentblock'
          disabled>
        </textarea>
      EOS
    end

    def markdown
      content_block = ::ContentBlock.find_by(
        audit_report_id: audit_report_id,
        name: @block_name
      )
      content_block ? content_block.markdown : ''
    end

    def mode
      @context.registers[:mode]
    end

    def rendered_markdown
      "<span data-contentblock-name='#{@block_name}'></span>" +
      renderer.render(markdown)
    end

    def renderer
      Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
    end
  end
end
