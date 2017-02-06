require 'rails_helper'

describe HandlerService do
  let(:service) { HandlerService.new(object_class: Apartment, params: params) }

  describe '.execute' do
    it 'creates the object if it does not exist' do
      expect { service.execute }.to change { Apartment.count }.by 1
    end

    it 'updates the object if it exists' do
      apartment = Apartment.create(params.merge(unit_number: 'aaaa'))
      service.params = params.merge(id: apartment.id)
      expect { service.execute }
        .to change { apartment.reload.unit_number }.from('aaaa').to('101a')
    end

    it 'deletes the object if destroy_attempt_on is set' do
      apartment = Apartment.create(params.merge(unit_number: 'aaaa'))
      service.params = params.merge(id: apartment.id,
                                    destroy_attempt_on: Time.current)
      expect { service.execute }
        .to change { Apartment.count }.from(1).to(0)
    end

    it 'raises an error if the object is invalid' do
      service.params = params.except('unit_number')
      expect { service.execute! }
        .to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Unit number can't be blank")
    end
  end

  def params
    { 'wegowise_id' => 345,
      'n_bedrooms' => 2,
      'unit_number' => '101a',
      'sqft' => 1000 }.with_indifferent_access
  end
end
