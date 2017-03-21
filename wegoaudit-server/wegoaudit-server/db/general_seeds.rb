require_relative 'seeds_support'

measure_selection_fields = load_fields_from_yaml(
  :measure_selection,
  'measure_selection')
MeasureSelection.all.each do |measure_selection|
  measure_selection_fields.each do |field|
    measure_selection.field_values.find_or_create_by!(
      field_api_name: field.api_name)
  end
end

audit_report_fields = load_fields_from_yaml(:audit_report, 'audit_report')
AuditReport.all.each do |audit_report|
  audit_report_fields.each do |field|
    audit_report.field_values.find_or_create_by!(field_api_name: field.api_name)
  end
end

CalcStructureType.find_or_create_by!(
  api_name: 'building', genus_api_name: 'building', name: 'Building')
