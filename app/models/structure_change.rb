class StructureChange < ActiveRecord::Base
  belongs_to :measure_selection
  belongs_to :structure_type

  delegate :audit, to: :measure_selection
  delegate :api_name, to: :structure_type, prefix: true

  has_many :field_values
  has_many :structures

  def determining_structure?
    structure_type_definition.determining?
  end

  def fields
    @fields ||= measure_selection.fields_for_structure_type(structure_type)
  end

  def grouped_structures
    @grouped_structures ||= begin
      available_structures =
        measure_selection.audit_report.all_structures.select do |structure|
          structure.structure_type.api_name == structure_type.api_name ||
            structure.structure_type.genus_api_name == structure_type.api_name
        end

      StructureListGrouper.new(
        measure_selection, structure_type, available_structures)
        .grouped_structures
    end
  end

  def interaction_field_values
    @interaction_fields ||= measure_selection.audit_report
      .original_structure_field_values.where(
        structure_wegoaudit_id: structure_wegoaudit_id
      )
  end

  def interaction_fields
    interaction_field_values.map(&:field)
  end

  def original_structure
    @original_structure ||= structures.find { |structure| !structure.proposed? }
  end

  def proposed_structure
    @proposed_structure ||= structures.find(&:proposed)
  end

  def structure_type_definition
    measure_selection.structure_type_definition_for(structure_type)
  end

  def wegoaudit_field_values
    wegoaudit_structure.field_values
  end

  def wegoaudit_structure
    return non_wegoaudit_structure unless structure_wegoaudit_id

    struct = grouped_structures.find do |structure|
      structure.id == structure_wegoaudit_id
    end

    struct || non_wegoaudit_structure
  end

  private

  def non_wegoaudit_structure
    TempStructure.new(
      id: SecureRandom.uuid,
      audit: audit,
      n_structures: 1,
      name: 'Unnamed',
      field_values: {},
      structure_type: { 'api_name' => structure_type.api_name }
    )
  end
end
