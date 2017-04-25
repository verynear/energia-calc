class CalcStructureCreator < Generic::Strict
  attr_accessor :measure,
                :proposed,
                :structure_change

  attr_reader :calc_structure

  def initialize(*)
    super
    self.proposed ||= false
    raise ArgumentError, 'measure' unless measure
    raise ArgumentError, 'structure_change' unless structure_change
  end

  def create
    execute
    calc_structure
  end

  def execute
    @calc_structure = structure_change.calc_structures.build(proposed: proposed)
    calc_structure.name = structure_change.wegoaudit_structure.description
    calc_structure.quantity = structure_change.wegoaudit_structure.n_structures
    calc_structure.save!

    create_field_values_for(calc_structure)
  end

  private

  def attributes_for_field(field)
    api_name = field.api_name
    values_from_audit = structure_change.wegoaudit_field_values[api_name]
    if values_from_audit
      values_from_audit.except('name', 'value_type', 'picker_value')
    else
      { value: '' }
    end
  end

  def create_field_value(calc_structure, field)
    attributes = attributes_for_field(field)
    # There's an ordering issue where you have to set field_api_name before you
    # can set value
    field_value = FieldValue.new(
      field_api_name: field.api_name,
      parent: calc_structure)
    field_value.attributes = attributes
    field_value.save!
  end

  def create_field_values_for(calc_structure)
    structure_change.fields.map do |field|
      proposed_only = structure_type_definition.proposed_only_field?(field)
      existing_only = structure_type_definition.existing_only_field?(field)

      next if !proposed && measure.inputs_only?
      next if !proposed && proposed_only
      next if proposed && existing_only
      next if !proposed && structure_change.interaction_fields.include?(field)

      create_field_value(calc_structure, field)
    end
  end

  def structure_type_definition
    measure.structure_type_definition_for(structure_change.calc_structure_type)
  end
end
