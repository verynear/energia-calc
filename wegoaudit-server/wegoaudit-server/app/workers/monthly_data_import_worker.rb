class MonthlyDataImportWorker
  include Sidekiq::Worker

  attr_reader :wegowise_client

  def perform(user_id, wegowise_id, structure_type, audit_report_id)
    current_user = User.find(user_id)
    @wegowise_client = WegowiseClient.new(user: current_user)
    save_structure_monthly_data(structure_type, wegowise_id, audit_report_id)
    process_building_monthly_data(wegowise_id, audit_report_id)
    save_usage_field_values(audit_report_id)
  end

  private

  def api_names
    [
      :electric_usage_in_kwh,
      :gas_usage_in_therms,
      :oil_usage_in_btu,
      :water_usage_in_gallons,
      :heating_usage_in_therms,
      :cooling_usage_in_therms
    ]
  end

  def data_types
    [
      { data_type: 'water', unit: 'gallons' },
      { data_type: 'electric', unit: 'kwh' },
      { data_type: 'gas', unit: 'therms' },
      { data_type: 'oil', unit: 'btu' },
      { data_type: 'heating', unit: 'therms' },
      { data_type: 'cooling', unit: 'therms' }
    ]
  end

  def process_building_monthly_data(wegowise_id, audit_report_id)
    data = BuildingMonthlyDatum.where(
      wegowise_id: wegowise_id,
      audit_report_id: audit_report_id)
    data.each do |datum|
      BuildingMonthlyDatumProcessor.new(datum: datum).execute
    end
  end

  def save_structure_monthly_data(structure_type, wegowise_id, audit_report_id)
    klass = "#{structure_type}MonthlyDatum".constantize

    data_types.each do |type|
      response = wegowise_client.structure_monthly_data(
        structure_type, wegowise_id, type[:data_type], type[:unit]
      )

      if wegowise_client.success? && response.present?
        klass.create!(
          wegowise_id: wegowise_id,
          audit_report_id: audit_report_id,
          data_type: type[:data_type],
          data: response
        )
      end
    end
  end

  def save_usage_field_values(audit_report_id)
    audit_report = AuditReport.find(audit_report_id)

    api_names.each do |field_api_name|
      field_value = audit_report.field_values.find_by!(
        field_api_name: field_api_name)

      data_type = field_api_name.to_s.split('_').first
      datum = BuildingMonthlyDatum.find_by(
        audit_report_id: audit_report_id,
        data_type: data_type)

      field_value.update(value: datum.yearly_data) if datum && datum.yearly_data
    end
  end
end
