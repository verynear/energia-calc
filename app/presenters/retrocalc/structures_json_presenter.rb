module Retrocalc
  class StructuresJsonPresenter
    MAPPING = {
      'r_value_of_existing_duct_insulation' => 'r_value',
      'seer' => 'seer_cooling_capacity',
      'duct_length' => 'length_of_duct',
      'perimeter_of_air_duct_cross_section' =>
        'perimeter_of_duct_cross_section',
      'hours_per_day_air_circulating' => 'air_circulating_hours_per_day',
      'year_manufactured' => 'year_built',
      'location' => 'region',
      'wattage' => 'watts_per_lamp',
      'measured_gpm' => 'gpm',
      'rated_gpf' => 'rated_gallons_per_flush',
      'air_flow_rating' => 'air_volume_in_cf_existing',
      'gas_total_usage_therms' => 'gas_usage_in_therms',
      'gas_heating_load_therms' => 'heating_usage_in_therms',
      'electricity_total_usage' => 'electric_usage_in_kwh',
      'electricity_cooling_load_therms' => 'cooling_usage_in_therms',
      'gas_baseload_therms' => 'heating_fuel_baseload_in_therms'

    }

    attr_accessor :n_structures,
                  :parent_structure,
                  :sample_group_id

    delegate :sample_groups,
             :substructures,
             to: :parent_structure

    def initialize(parent_structure, n_structures = 1, sample_group_id = nil)
      self.parent_structure = parent_structure
      self.n_structures = n_structures
      self.sample_group_id = sample_group_id
    end

    def as_json
      sample_groups.each do |sample_group|
        substructures.concat(sample_group.substructures)
      end

      exportable_substructures.map { |audit_structure| structure_json(audit_structure) }
    end

    private

    def exportable_substructures
      substructures.select do |substructure|
        substructure.physical_structure_type != 'Building' ||
          substructure.physical_structure.wegowise_id != 0
      end
    end

    def field_json(audit_field)
      {
        name: audit_strc_type.name,
        api_name: audit_strc_type.api_name
      }
    end

    def fields_for(audit_structure)
      audit_field_values = audit_structure.audit_field_values.includes(:audit_field)

      audit_field_values.each_with_object({}) do |value, hash|
        api_name = value.audit_field.api_name
        api_name = MAPPING[api_name] if MAPPING[api_name]

        hash[api_name] = { value: value.value,
                           name: value.audit_field.name,
                           value_type: value.audit_field.value_type }
      end
    end

    def n_structures_for(audit_structure)
      sample_group = audit_structure.sample_group

      if sample_group.present?
        self.n_structures = (sample_group.n_structures /
          sample_group.substructures.count).round(3)
      end
      n_structures
    end

    def sample_group_id_for(audit_structure)
      if audit_structure.sample_group.present?
        self.sample_group_id = audit_structure.sample_group.id
      end
      sample_group_id
    end

    def structure_json(audit_structure)
      {
        id: audit_structure.id,
        name: audit_structure.name,
        structure_type: structure_type_json(audit_structure.audit_strc_type),
        wegowise_id: wegowise_id(audit_structure),
        field_values: fields_for(audit_structure),
        n_structures: n_structures_for(audit_structure),
        sample_group_id: sample_group_id_for(audit_structure),
        photos: PhotosJsonPresenter.new(audit_structure).as_json,
        substructures: StructuresJsonPresenter.new(
          audit_structure, n_structures, sample_group_id).as_json
      }
    end

    def structure_type_json(audit_strc_type)
      {
        name: audit_strc_type.name,
        api_name: audit_strc_type.api_name
      }
    end

    def wegowise_id(audit_structure)
      return nil if audit_structure.physical_structure.nil?
      audit_structure.physical_structure.wegowise_id
    end
  end
end
