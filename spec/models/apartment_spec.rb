require 'rails_helper'

describe Apartment do
  let(:params) { {unit_number: '1', wegowise_id: 1} }

  it { should validate_presence_of :unit_number }

  it 'should allow only one non-cloned instance with the same wegowise_id' do
    Apartment.create(params.merge(cloned: false))
    apt = Apartment.create(params.merge(cloned: false))

    expect(apt.errors.messages[:base])
      .to eq(["There can be only one non-cloned Apartment with
              Wegowise Id 1".squish])
  end

  it 'should allow more than one cloned instance with the same wegowise_id' do
    Apartment.create(params.merge(cloned: false))
    expect(Apartment.create(params).valid?).to eq true
    expect(Apartment.create(params).valid?).to eq true
  end

  specify '#name= sets the unit_number' do
    apartment = Apartment.new
    apartment.name = '6B'
    expect(apartment.unit_number).to eq '6B'
  end

  specify '#name returns the unit number' do
    apartment = Apartment.new(unit_number: '6B')
    expect(apartment.name).to eq '6B'
  end
end
