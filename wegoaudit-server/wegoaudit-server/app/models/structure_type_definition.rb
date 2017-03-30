class StructureTypeDefinition < Generic::Strict
  attr_accessor :definition,
                :calc_fields,
                :name,
                :calc_structure_type

  def determining?
    definition.fetch(:determining, false)
  end

  def existing_only_field?(calc_field)
    field_definitions.fetch(calc_field.api_name.to_sym, {})[:existing_only]
  end

  def calc_field_definitions
    definition.fetch(:calc_fields, {})
  end

  def grouping_field_api_name
    definition[:field_for_grouping].try(:to_sym)
  end

  def multiple?
    definition.fetch(:multiple, false)
  end

  def proposed_only_field?(calc_field)
    calc_field_definitions.fetch(calc_field.api_name.to_sym, {})[:proposed_only]
  end
end
