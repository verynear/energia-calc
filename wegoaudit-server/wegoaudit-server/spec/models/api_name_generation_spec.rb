require 'rails_helper'

describe ApiNameGeneration do
  class ApiNameGenerationTest
    def self.validate(*)
    end

    include ApiNameGeneration

    attr_accessor :name,
                  :api_name
  end

  let(:instance) { ApiNameGenerationTest.new }

  describe '#generate_api_name' do
    it 'underscores a name' do
      instance.name = 'Domestic Hot Water'
      instance.generate_api_name
      expect(instance.api_name).to eq('domestic_hot_water')
    end

    it 'strips outs non-alpha characters' do
      instance.name = '"I said, (parenthetically),\'...\'"'
      instance.generate_api_name
      expect(instance.api_name).to eq('i_said_parenthetically')
    end
  end
end
