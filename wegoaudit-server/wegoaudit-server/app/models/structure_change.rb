class StructureChange < ActiveRecord::Base
  belongs_to :measure_selection
  belongs_to :calc_structure_type

  delegate :temp_audit, to: :measure_selection
  delegate :api_name, to: :calc_structure_type, prefix: true

  has_many :calc_field_values
  has_many :calc_structures

  def determining_structure?
    structure_type_definition.determining?
  end

  def calc_fields
    @calc_fields ||= measure_selection.fields_for_structure_type(calc_structure_type)
  end

  def grouped_structures
    @grouped_structures ||= begin
      available_structures =
        measure_selection.audit_report.all_structures.select do |calc_structure|
          calc_structure.calc_structure_type.api_name == calc_structure_type.api_name ||
            calc_structure.calc_structure_type.genus_api_name == calc_structure_type.api_name
        end

      StructureListGrouper.new(
        measure_selection, calc_structure_type, available_structures)
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
    @original_structure ||= calc_structures.find { |calc_structure| !calc_structure.proposed? }
  end

  def proposed_structure
    @proposed_structure ||= calc_structures.find(&:proposed)
  end

  def structure_type_definition
    measure_selection.structure_type_definition_for(calc_structure_type)
  end

  def wegoaudit_field_values
    wegoaudit_structure.calc_field_values
  end

  def wegoaudit_structure
    return non_wegoaudit_structure unless structure_wegoaudit_id

    struct = grouped_structures.find do |calc_structure|
      calc_structure.id == structure_wegoaudit_id
    end

    struct || non_wegoaudit_structure
  end

  private

  def non_wegoaudit_structure
    TempStructure.new(
      id: SecureRandom.uuid,
      temp_audit: temp_audit,
      n_structures: 1,
      name: 'Unnamed',
      calc_field_values: {},
      calc_structure_type: { 'api_name' => calc_structure_type.api_name }
    )
  end
end
