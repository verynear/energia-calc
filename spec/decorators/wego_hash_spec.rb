require 'rails_helper'

describe WegoHash do
  let(:original_hash) do
    { id: 'foo',
      alpha: 'beta',
      type: 'foo_type',
      bar: { id: 'bar',
             'gamma' => 'delta',
             type: 'bar_type',
             baz: { 'id' => 'baz',
                    'epsilon' => 'zeta',
                    'type' => 'baz_type' } } }
  end
  let(:hash) { WegoHash.new(original_hash) }

  it 'converts the hash to a HashWithIndifferentAccess' do
    expect(hash[:wegowise_id]).to eq hash['wegowise_id']
  end

  it 'renames any "id" keys to wegowise_id' do
    expect(hash.has_key?(:id)).to eq false
    expect(hash[:wegowise_id]).to eq original_hash[:id]
    expect(hash['bar'].has_key?(:id)).to eq false
    expect(hash['bar'][:wegowise_id]).to eq original_hash[:bar][:id]
    expect(hash['bar']['baz'].has_key?(:id)).to eq false
    expect(hash['bar']['baz'][:wegowise_id])
      .to eq original_hash[:bar][:baz]['id']
  end

  it 'renames any "type" keys to object_type' do
    expect(hash.has_key?(:type)).to eq false
    expect(hash[:object_type]).to eq original_hash[:type]
    expect(hash['bar'].has_key?(:type)).to eq false
    expect(hash['bar'][:object_type]).to eq original_hash[:bar][:type]
    expect(hash['bar']['baz'].has_key?(:type)).to eq false
    expect(hash['bar']['baz'][:object_type])
      .to eq original_hash[:bar][:baz]['type']
  end

  it 'converts any fields that have been specified as a conversion' do
    conversions = { alpha: :alpha_converted, gamma: 'gamma_converted'}
    hash = WegoHash.new(original_hash, conversions: conversions)
    expect(hash[:alpha_converted]).to eq(original_hash[:alpha])
    expect(hash[:bar][:gamma_converted]).to eq(original_hash[:bar]['gamma'])
  end

  describe '.flatten' do
    it "flattens any hash values prefixing with the value's key" do
      expected_hash = { wegowise_id: 'foo',
                        alpha: 'beta',
                        object_type: 'foo_type',
                        bar_wegowise_id: 'bar',
                        bar_object_type: 'bar_type',
                        bar_gamma: 'delta',
                        bar_baz_wegowise_id: 'baz',
                        bar_baz_epsilon: 'zeta',
                        bar_baz_object_type: 'baz_type' }.with_indifferent_access
      expect(hash.flatten).to eq(expected_hash)
    end
    it "flattens any hash values prefixing with the value's key unless " +
       "without_prefix is specified" do
      expected_hash = { wegowise_id: 'foo',
                        alpha: 'beta',
                        object_type: 'foo_type',
                        gamma: 'delta',
                        baz_wegowise_id: 'baz',
                        baz_epsilon: 'zeta',
                        baz_object_type: 'baz_type' }.with_indifferent_access
      expect(hash.flatten(without_prefix: :bar)).to eq(expected_hash)
    end
  end
end
