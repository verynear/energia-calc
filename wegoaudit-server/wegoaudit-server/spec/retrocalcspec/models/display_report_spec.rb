require 'rails_helper'

describe DisplayReport do
  describe '#formatted_report' do
    it 'produces html from markdown' do
      report = described_class.new(markdown: '**hello world**')
      expect(report.formatted_report)
        .to eq("<p><strong>hello world</strong></p>\n")
    end

    it 'passes locals into liquid tags' do
      report = described_class.new(
        markdown: '**hello {{ name }}**',
        locals: { name: 'you' })
      expect(report.formatted_report)
        .to eq("<p><strong>hello you</strong></p>\n")
    end
  end
end
