require_relative 'seeds_support'

audit_structure_type = AuditStrcType.find_or_create_by(
  name: 'Audit',
  active: true,
  display_order: 1,
  primary: true)

audit_types = [
  'Energy Savers Audit',
  'NEI Existing Bldg',
  'Michigan',
  'Green Coast',
  'Elevate SMF',
  'Elevate Non-Profit',
  'Water Only',
  'NEI New Con',
  'AHRAE Level 2'
]


audit_types.each_with_index do |audit_name, index|
  AuditType.find_or_create_by(
    name: audit_name,
    active: true)
end

audit_measures = [
  'Air Conditioner Replacement',
  'Air Sealing',
  'Boiler Controls',
  'DHW, Heater Replacement or Tune-Up',
  'DHW, On-Demand Circulating Pump',
  'DHW, Showerheads',
  'DHW, Bathroom Faucets',
  'DHW, Kitchen Faucets',
  'DHW, Toilets',
  'DHW, Clothes Washers',
  'DHW, Leaks',
  'DHW, Other',
  'Heat Recovery Ventilation',
  'Insulation, Envelope',
  'Lighting',
  'Pipe Insulation, DHW',
  'Pipe Insulation, HHW',
  'Pipe Insulation, Steam',
  'Thermostats, Programmable and/or temp limiting',
  'Variable Speed pumps',
  'Window, Replacement or Storm',
  'Dishwashers',
  'Vending - fridge and lighting',
  'Attic reflective barrier',
  'Chillers',
  'Cooling towers',
  'Abatement meter',

  # Measures implemented in Retrocalc
  'Boiler Replacement or Tune-Up',
  'DHW Pipe Insulation',
  'DHW Replacement',
  'Duct Air Sealing (heating and cooling)',
  'Duct Insulation',
  'Exterior Lighting and Controls',
  'Furnace Replacement or Tune-Up',
  'Install Cogeneration System',
  'Install Temperature-Limiting Thermostats',
  'Interior Lighting and Controls',
  'Refrigerator Replacement',
  'Sewer Abatement',
  'Solar PV',
  'Solar Thermal',
  'Steam Vent Replacement',
  'Toilet Replacement',
  'Upgrade Ventilation System'
]

non_standard_api_names = {
  'Boiler Replacement or Tune-Up' => 'boiler_replacement',
  'Duct Air Sealing (heating and cooling)' => 'duct_air_sealing',
  'Furnace Replacement or Tune-Up' => 'furnace_replacement'
}

audit_measures.each do |measure_name|
  audit_measure = AuditMeasure.find_or_create_by(name: measure_name)

  if non_standard_api_names[measure_name]
    audit_measure.update_column(:api_name, non_standard_api_names[measure_name])
  end
end

DynamicSchemaImporter.execute!

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

Organization.find_or_create_by!(
  id: '19cfb419-f657-49e2-a543-d5af358a4e9c',
  name: 'Retrocalc Testers',
  owner_id: '0f664c6d-7b18-4826-80f5-c4be7b134a29',
  wegowise_id: 20
)

Organization.find_or_create_by!(
  id: '29efb419-f657-69e2-a543-f5af358a4e5d',
  name: 'Elevate Energy',
  owner_id: 'b3d3a144-b119-4c4e-a94e-cf1d6ddc21e8',
  wegowise_id: 22
)

Organization.find_or_create_by!(
  id: '856acf1c-b83d-4325-b54a-466b1416aa05',
  name: 'New Ecology',
  owner_id: '786c9d96-b181-4435-a132-c6f543a3dd52',
  wegowise_id: 18
)

StructureType.find_or_create_by!(
  api_name: 'building', genus_api_name: 'building', name: 'Building')

load_fields_from_yaml(:structure, 'structure')

structure_types = YAML.load_file(
  Rails.root.join('db', 'fixtures', 'structure_types.yml'))

structure_types.each do |api_name, options|
  structure_type = StructureType.find_or_initialize_by(
    api_name: api_name,
    name: options['name'],
    genus_api_name: api_name)
  begin
    structure_type.save!
  rescue ActiveRecord::RecordInvalid => e
    raise "Problem with #{structure_type.api_name}: #{e}"
  end
end

measures = {
  boiler_replacement: 'Boiler Replacement or Tune-Up',
  dhw_pipe_insulation: 'DHW Pipe Insulation',
  dhw_replacement: 'DHW Replacement',
  duct_air_sealing: 'Duct Air Sealing (heating and cooling)',
  duct_insulation: 'Duct Insulation',
  furnace_replacement: 'Furnace Replacement or Tune-Up',
  install_cogeneration_system: 'Install Cogeneration System',
  install_temperature_limiting_thermostats:
    'Install Temperature-Limiting Thermostats',
  interior_lighting_and_controls: 'Interior Lighting and Controls',
  pipe_insulation: 'Pipe Insulation',
  refrigerator_replacement: 'Refrigerator Replacement',
  sewer_abatement: 'Sewer Abatement',
  showerheads: 'Showerheads',
  solar_pv: 'Solar PV',
  solar_thermal: 'Solar Thermal',
  steam_vent_replacement: 'Steam Vent Replacement',
  toilet_replacement: 'Toilet Replacement',
  upgrade_ventilation_system: 'Upgrade Ventilation System'
}

measures.each do |api_name, measure_name|
  measure = Measure.find_or_initialize_by(api_name: api_name)
  measure.name = measure_name
  measure.save!
end
