require_relative 'seeds_support'

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