require 'rails_helper'

describe MonthlyDataImportWorker do
  describe '#perform' do
    let(:user) { create(:user) }
    let(:client) { instance_double(WegowiseClient) }
    let(:audit_report) { create(:audit_report) }
    let(:worker) { described_class.new }

    before do
      # TODO: this stubbing of the object under test is a bad idea
      allow(worker).to receive(:api_names).and_return(
        [
          :electric_usage_in_kwh,
          :cooling_usage_in_therms
        ]
      )
      allow(worker).to receive(:data_types).and_return(
        [
          { data_type: 'electric', unit: 'kwh' },
          { data_type: 'cooling', unit: 'therms' }
        ]
      )

      create(:field,
             name: 'Electric usage in kwh',
             api_name: 'electric_usage_in_kwh',
             value_type: 'decimal')
      create(:field,
             name: 'Cooling usage in therms',
             api_name: 'cooling_usage_in_therms',
             value_type: 'decimal')

      audit_report.field_values.create!(
        field_api_name: 'electric_usage_in_kwh')
      audit_report.field_values.create!(
        field_api_name: 'cooling_usage_in_therms')

      allow(WegowiseClient).to receive(:new).and_return(client)
    end

    it 'creates BuildingMonthlyDatum records if data is present' do
      electric_data = [{ 'date' => 'date', 'value' => 1.0 }]
      cooling_data = [{ 'date' => 'date', 'value' => 2.0 }]
      processor = instance_double(BuildingMonthlyDatumProcessor)

      allow(client).to receive(:success?).and_return(true)

      expect(client).to receive(:structure_monthly_data)
        .with('Building', 123, 'electric', 'kwh')
        .and_return(electric_data)
      expect(client).to receive(:structure_monthly_data)
        .with('Building', 123, 'cooling', 'therms')
        .and_return(cooling_data)

      expect(BuildingMonthlyDatumProcessor).to receive(:new)
        .and_return(processor).twice
      expect(processor).to receive(:execute).twice

      expect { worker.perform(user.id, 123, 'Building', audit_report.id) }
        .to change { BuildingMonthlyDatum.count }.from(0).to(2)

      expect(audit_report.building_monthly_data.count).to eq(2)

      electric_datum = BuildingMonthlyDatum.find_by(
        wegowise_id: 123, data_type: 'electric')
      expect(electric_datum.data).to eq(electric_data)

      cooling_datum = BuildingMonthlyDatum.find_by(
        wegowise_id: 123, data_type: 'cooling')
      expect(cooling_datum.data).to eq(cooling_data)
    end

    it 'saves usage field values' do
      electric_data = [
        { date: '2014-04-01', value: 2.0 },
        { date: '2014-05-01', value: 2.0 },
        { date: '2014-06-01', value: 2.0 }
      ]

      cooling_data = [
        { date: '2014-04-01', value: 2.0 },
        { date: '2014-05-01', value: 2.0 },
        { date: '2014-06-01', value: 2.0 },
        # start of months that will be used
        { date: '2014-07-01', value: 4.0 },
        { date: '2014-08-01', value: 4.0 },
        { date: '2014-09-01', value: 4.0 },
        { date: '2014-10-01', value: 4.0 },
        { date: '2014-11-01', value: 4.0 },
        { date: '2014-12-01', value: 4.0 },
        { date: '2015-01-01', value: 4.0 },
        { date: '2015-02-01', value: 4.0 },
        { date: '2015-03-01', value: 4.0 },
        { date: '2015-04-01', value: 4.0 },
        { date: '2015-05-01', value: 4.0 },
        { date: '2015-06-01', value: 4.0 },
        # gap in months
        { date: '2015-08-01', value: 6.0 }
      ]

      allow(client).to receive(:success?).and_return(true)

      expect(client).to receive(:structure_monthly_data)
        .with('Building', 123, 'electric', 'kwh')
        .and_return(electric_data)
      expect(client).to receive(:structure_monthly_data)
        .with('Building', 123, 'cooling', 'therms')
        .and_return(cooling_data)

      worker.perform(user.id, 123, 'Building', audit_report.id)

      electric_fv = audit_report.field_values.find_by(
        field_api_name: 'electric_usage_in_kwh')
      cooling_fv = audit_report.field_values.find_by(
        field_api_name: 'cooling_usage_in_therms')

      expect(electric_fv.value).to eq nil
      expect(cooling_fv.value).to eq 48.0
    end

    it 'creates ApartmentMonthlyDatum records if data is present' do
      electric_data = [{ 'date' => 'date', 'value' => 3.0 }]
      cooling_data = [{ 'date' => 'date', 'value' => 4.0 }]

      allow(client).to receive(:success?).and_return(true)

      expect(client).to receive(:structure_monthly_data)
        .with('Apartment', 456, 'electric', 'kwh')
        .and_return(electric_data)
      expect(client).to receive(:structure_monthly_data)
        .with('Apartment', 456, 'cooling', 'therms')
        .and_return(cooling_data)

      expect { worker.perform(user.id, 456, 'Apartment', audit_report.id) }
        .to change { ApartmentMonthlyDatum.count }.from(0).to(2)

      expect(audit_report.apartment_monthly_data.count).to eq(2)

      electric_datum = ApartmentMonthlyDatum.find_by(
        wegowise_id: 456, data_type: 'electric')
      expect(electric_datum.data).to eq(electric_data)

      cooling_datum = ApartmentMonthlyDatum.find_by(
        wegowise_id: 456, data_type: 'cooling')
      expect(cooling_datum.data).to eq(cooling_data)
    end

    it 'does not create MonthlyDatum records unless success response' do
      allow(client).to receive(:structure_monthly_data)
      allow(client).to receive(:success?).and_return(false)

      expect { worker.perform(user.id, 0, 'Building', audit_report.id) }
        .to_not change { BuildingMonthlyDatum.count }
    end
  end
end
