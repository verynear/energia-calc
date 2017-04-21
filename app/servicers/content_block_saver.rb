class ContentBlockSaver < Generic::Strict
  attr_accessor :audit_report_id,
                :content_block_params

  def execute
    content_block_params.each do |block_name, markdown|
      content_block = ContentBlock.find_or_create_by(
        audit_report_id: audit_report_id,
        name: block_name
      )
      content_block.update(markdown: markdown.strip)
    end
  end
end
