class MeasureSelectionSerializer < Generic::Strict
  attr_accessor :measure_selection,
                :measure_summary

  def as_json
    {
      id: measure_selection.id,
      calculate_order: measure_selection.calculate_order,
      enabled: measure_selection.enabled,
      name: measure_selection.calc_measure_name,
      notes: measure_selection.notes,
      report_id: measure_selection.audit_report_id,
      structure_changes: structure_changes_as_json,
      measure_summary: measure_summary_as_json,
      photos: photos_as_json,
      selected_photo_id: measure_selection.wegoaudit_photo_id
    }
  end

  def measure_summary_as_json
    MeasureSummarySerializer.new(
      measure_summary: measure_summary).as_json
  end

  def photos_as_json
    if audit_photos_json && structure_photos_json
      audit_photos_json + structure_photos_json
    end
  end

  def structure_changes_as_json
    measure_selection.structure_changes.map do |structure_change|
      StructureChangeSerializer.new(
        structure_change: structure_change,
        measure_selection: measure_selection,
        measure_summary: measure_summary
      ).as_json
    end
  end

  private

  def audit_photos_json
    measure_selection.audit_report.temp_audit.photos
  end

  def structure_photos_json
    measure_selection.structure_changes.flat_map do |structure_change|
      structure_change.wegoaudit_structure.photos
    end
  end
end
