audit_structure_type = StructureType.find_or_create_by(
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

measures = [
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

measures.each do |measure_name|
  measure = Measure.find_or_create_by(name: measure_name)

  if non_standard_api_names[measure_name]
    measure.update_column(:api_name, non_standard_api_names[measure_name])
  end
end

DynamicSchemaImporter.execute!
