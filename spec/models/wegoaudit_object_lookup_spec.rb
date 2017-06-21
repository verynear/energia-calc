require 'rails_helper'

describe WegoauditObjectLookup do
  class WegoauditObjectLookupTestClass
    include WegoauditObjectLookup

    def self.all
    end
  end

  describe '.by_api_name' do
    it 'lazy loads records only once and performs a lookup' do
      object1 = double(api_name: 'foo')
      object2 = double(api_name: 'bar')
      object3 = double(api_name: 'baz')
      expect(WegoauditObjectLookupTestClass).to receive(:all)
        .exactly(:once)
        .and_return(double(to_a: [object1, object2, object3]))
      expect(WegoauditObjectLookupTestClass.by_api_name('bar')).to eq(object2)
      expect(WegoauditObjectLookupTestClass.by_api_name('baz')).to eq(object3)
    end
  end
end
