require 'rails_helper'

describe StructureImage do
  it { should belong_to(:structure) }
  it { should have_attached_file(:asset) }
  it { should validate_attachment_content_type(:asset)
              .allowing('image/jpg', 'image/jpeg') }
  it { should validate_presence_of(:file_name) }

  describe '#absolute_url' do
    let(:image) { described_class.new }
    let(:asset) { double(url: '/asset_path') }

    before do
      stub_const('WegoAudit::BASE_URL', 'base_url')
      allow(image).to receive(:asset).and_return(asset)
    end

    it 'prepends WegoAudit base url to asset path' do
      expect(image.absolute_url(:foo)).to eq('base_url/asset_path')
    end

    it 'passes style argument to asset url method' do
      expect(asset).to receive(:url).with(:foo)
      image.absolute_url(:foo)
    end
  end
end
