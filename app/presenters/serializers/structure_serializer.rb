class StructureSerializer < Generic::Strict
  attr_accessor :effective_structure_values,
                :measure_selection,
                :calc_structure,
                :structure_change

  def as_json
    {
      id: calc_structure.id,
      api_name: structure_change.calc_structure_type_api_name,
      field_values: field_values_as_json,
      original_structure_field_values: original_structure_field_values_as_json,
      name_field_value: {
        id: calc_structure.id,
        name: 'Name',
        value: calc_structure.name,
        value_type: 'string',
        original_value: calc_structure.original_name,
        from_audit: true
      },
      quantity_field_value: {
        id: calc_structure.id,
        name: 'Quantity',
        value: calc_structure.quantity,
        value_type: 'integer',
        original_value: calc_structure.original_quantity,
        from_audit: false
      },
      multiple: structure_change.structure_type_definition.multiple?,
      sample_group: calc_structure.sample_group?,
      proposed: calc_structure.proposed?
    }
  end

  private

  def field_values_as_json
    calc_structure.field_values.map do |field_value|
      {
        id: field_value.id,
        name: field_value.field_name,
        value: field_value.value,
        value_type: field_value.value_type,
        original_value: field_value.original_value,
        from_audit: field_value.from_audit,
        api_name: field_value.field_api_name,
        options: field_value.field_options,
        default: measure_selection.defaults[field_value.field_api_name.to_sym]
      }
    end
  end

  def original_structure_field_values_as_json
    return [] if calc_structure.proposed?

    structure_change.interaction_field_values.map do |field_value|
      # TODO: the amount of work to get this value here is a code smell
      effective_value =
        effective_structure_values[field_value.field_api_name] ||
          field_value.value

      {
        # There is a bug in backbone-relational that causes it to drop
        # additional instances with the same id. Use real_id for ajax requests
        id: SecureRandom.uuid,
        real_id: field_value.id,
        name: field_value.field_name,
        value: field_value.value,
        effective_value: effective_value,
        value_type: field_value.value_type,
        original_value: field_value.original_value,
        from_audit: field_value.from_audit,
        api_name: field_value.field_api_name,
        audit_report_id: field_value.audit_report_id,
        structure_wegoaudit_id: structure_change.structure_wegoaudit_id,
        measure_selection_id: measure_selection.id
      }
    end
  end
end
