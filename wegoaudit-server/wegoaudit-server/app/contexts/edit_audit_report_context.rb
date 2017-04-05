class EditAuditReportContext < BaseContext
  attr_accessor :audit_report,
                :user

  def audit_report_as_json
    { audit_report: audit_report_json,
      fields: fields }
  end

  private

  def audit_report_json
    {
      id: audit_report.id,
      audit_report_summary: audit_report_summary_json,
      field_values: field_values_as_json,
      audit_report_name_field_value: {
        id: audit_report.id,
        name: 'Report name',
        value: audit_report.name,
        value_type: 'string',
        original_value: audit_report.audit.name,
        from_audit: true
      }
    }
  end

  def audit_report_summary_json
    audit_report_calculator = AuditReportCalculator.new(audit_report: audit_report)
    AuditReportSummarySerializer.new(
      audit_report: audit_report,
      audit_report_calculator: audit_report_calculator).as_json
  end

  def field_values_as_json
    fields = [
      :id,
      :value,
      :field_api_name
    ]
    audit_report.calc_field_values.pluck_to_hash(*fields).map do |row|
      field = CalcField.by_api_name!(row[:field_api_name])

      if row[:field_api_name] == 'location_for_temperatures'
        field_options = location_for_temperature_options
      else
        field_options = field.options
      end

      {
        id: row[:id],
        name: field.name,
        value: row[:value],
        value_type: field.value_type,
        original_value: nil,
        from_audit: false,
        api_name: row[:field_api_name],
        options: field_options
      }
    end
  end

  def fields
    [
      {
        title: 'Basic',
        rows: [
          [:report_name, :audit_date, :auditor_name, :auditor_email]
        ]
      },
      {
        title: 'Client information',
        rows: [
          [:contact_name, :contact_company, :contact_phone, :contact_email],
          [:contact_address, :contact_city, :contact_state],
          [:contact_zip]
        ]
      },
      { title: 'Temperature data',
        rows: [
          [
            :location_for_temperatures,
            :heating_season_start_month,
            :heating_season_end_month,
            :heating_degree_days
          ],
          [
            :average_indoor_temperature
          ]
        ]
      },
      {
        title: 'Building characteristics',
        rows: [
          [
            :building_name,
            :building_address
          ],
          [
            :building_city,
            :building_state,
            :building_zip
          ],
          [
            :building_sqft,
            :num_apartments,
            :num_occupants,
            :num_bathrooms
          ],
          [
            :num_stories,
            :num_bedrooms
          ]
        ]
      },
      {
        title: 'Utility costs',
        rows: [
          [
            :electric_cost_per_kwh,
            :gas_cost_per_therm,
            :oil_cost_per_btu,
            :water_cost_per_gallon
          ]
        ]
      },
      {
        title: 'Utility usage',
        rows: [
          [
            :electric_usage_in_kwh,
            :gas_usage_in_therms,
            :oil_usage_in_btu,
            :water_usage_in_gallons
          ],
          [
            :heating_usage_in_therms,
            :cooling_usage_in_therms,
            :heating_fuel_baseload_in_therms
          ]
        ]
      },
      {
        title: 'SIR-related',
        rows: [
          [
            :escalation_rate,
            :inflation_rate,
            :interest_rate
          ]
        ]
      }
    ]
  end

  def location_for_temperature_options
    field_options = TemperatureLocation.order(:location)
      .pluck_to_hash(:location, :state_code)
    [['', '']] +
      field_options.map do |row|
        ["#{row[:location]}, #{row[:state_code]}", row[:location]]
      end
  end
end
