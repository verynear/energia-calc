module Retrocalc
  class AuditJsonPresenter
    MAPPING = {
      'auditor_name' => 'auditor_name',
      'auditor_email' => 'auditor_email',
      'name' => 'contact_name',
      'phone_number' => 'contact_phone',
      'email_address' => 'contact_email',
      'address' => 'contact_address',
      'city' => 'contact_city',
      'state' => 'contact_state',
      'zip_code' => 'contact_zip',
      'holding_company' => 'contact_company',
      'gas_total_usage_therms' => 'gas_usage_in_therms',
      'gas_heating_load_therms' => 'heating_usage_in_therms',
      'electricity_total_usage' => 'electric_usage_in_kwh',
      'electricity_cooling_load_therms' => 'cooling_usage_in_therms',
      'gas_baseload_therms' => 'heating_fuel_baseload_in_therms',
      'water_total_usage_gal' => 'water_usage_in_gallons',
      'oil_total_usage_btu' => 'oil_usage_in_btu',
      'utility_water_cost_gal' => 'water_cost_per_gallon',
      'utility_electric_cost_kwh' => 'electric_cost_per_kwh',
      'utility_gas_cost_thm' => 'gas_cost_per_therm',
      'utility_oil_cost_btu' => 'oil_cost_per_btu',
      'nominal_escalation_rate' => 'escalation_rate',
      'nominal_interest_rate' => 'interest_rate'
    }

    attr_accessor :audit,
                  :top_level_only

    def initialize(audit, top_level_only: false)
      self.audit = audit
      self.top_level_only = top_level_only
    end

    def as_json(options = {})
      top_level = {
        id: audit.id,
        name: audit.name,
        date: audit.performed_on,
        field_values: fields_for(audit),
        audit_type: audit.audit_type.try(:name)
      }

      return top_level if top_level_only

      top_level[:temp_structures] = structures_json
      top_level[:sample_groups] = sample_groups_json
      top_level[:photos] = photos_json

      top_level
    end

    private

    def fields_for(audit)
      audit_field_values = audit.audit_field_values.includes(:audit_field)

      audit_field_values.each_with_object({}) do |value, hash|
        api_name = value.audit_field.api_name
        api_name = MAPPING[api_name] if MAPPING[api_name]

        hash[api_name] = value.value 
      end
    end

    def photos_json
      Retrocalc::PhotosJsonPresenter.new(audit.audit_structure).as_json
    end

    def sample_groups_json
      Retrocalc::SampleGroupsJsonPresenter.new(audit.audit_structure).as_json
    end

    def structures_json
      Retrocalc::StructuresJsonPresenter.new(audit.audit_structure).as_json
    end
  end
end
