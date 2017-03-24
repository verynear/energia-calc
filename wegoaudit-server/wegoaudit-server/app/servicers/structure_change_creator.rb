class StructureChangeCreator < Generic::Strict
  attr_accessor :calc_measure,
                :measure_selection,
                :calc_structure_type,
                :structure_wegoaudit_id

  attr_reader :structure_change

  def create
    execute
    structure_change
  end

  def execute
    raise 'structure_wegoaudit_id' unless structure_wegoaudit_id

    ActiveRecord::Base.transaction do
      create_structure_change

      create_original_structure_field_values

      create_structure(proposed: false)
      create_structure(proposed: true)
    end
  end

  private

  def create_original_structure_field_values
    measure_selection
      .interaction_fields_for(structure_change.calc_structure_type)
      .each do |field_api_name|
        measure_selection.audit_report.original_structure_field_values
          .find_or_create_by!(
            field_api_name: field_api_name,
            structure_wegoaudit_id: structure_wegoaudit_id
          )
      end
  end

  def create_structure(**options)
    creator = StructureCreator.new(
      { calc_measure: measure_selection.calc_measure,
        structure_change: structure_change }.merge(options)
    )
    creator.create
  end

  def create_structure_change
    @structure_change = measure_selection.structure_changes.create!(
      structure_wegoaudit_id: structure_wegoaudit_id,
      calc_structure_type: calc_structure_type
    )
  end
end
