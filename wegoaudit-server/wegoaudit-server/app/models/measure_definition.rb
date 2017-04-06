class MeasureDefinition < Generic::Strict
  attr_accessor :kilomeasure_measure,
                :local_definition,
                :name

  delegate :data_types,
           :defaults,
           :inputs_only?,
           :run_retrofit_calculations,
           :run_calculations,
           :for_water?,
           :for_electric?,
           :for_gas?,
           :for_oil?,
           :for_water_heating?,
           :for_building_heating?,
           to: :kilomeasure_measure

  def self.get(api_name)
    MeasureDefinitionsRegistry.get(api_name)
  end

  def fields_for_structure_type(calc_structure_type)
    structure_type_definition = structure_type_definition_for(calc_structure_type)
    return [] unless structure_type_definition

    structure_type_definition.calc_fields
  end
  memoize :fields_for_structure_type

  def fields_mapping
    local_definition[:fields_mapping] || {}
  end

  def inputs_hash
    local_definition.fetch(:inputs, {}).symbolize_keys
  end
  memoize :inputs_hash

  def interaction_fields
    local_definition[:interaction_fields] || []
  end

  def interaction_fields_for(calc_structure_type)
    fields_for_structure_type(calc_structure_type).map(&:api_name) &
      interaction_fields
  end

  def measure_fields
    measure_inputs = inputs_hash.fetch(:measure, {})
    fields_from_measure = measure_inputs.map do |field_name|
      get_field(field_name)
    end
    fields_from_measure | default_measure_fields
  end
  memoize :measure_fields

  def structure_type_definition_for(structure_type)
    structure_type_definitions.find do |structure_type_definition|
      structure_type_definition.calc_structure_type == structure_type
    end
  end
  memoize :structure_type_definition_for

  def structure_type_definitions
    inputs_hash.map do |st_api_name, field_names|
      next if [:measure, :audit].include?(st_api_name)

      fields = field_names.map do |api_name|
        get_field(api_name)
      end

      definition_hash = local_definition.fetch(:structures, {})
        .fetch(st_api_name.to_sym, {})

      calc_structure_type = CalcStructureType.by_api_name!(st_api_name)
      StructureTypeDefinition.new(
        name: st_api_name,
        definition: definition_hash,
        calc_fields: fields,
        calc_structure_type: calc_structure_type
      )
    end.compact
  end
  memoize :structure_type_definitions

  def structure_types
    structure_type_definitions.map(&:calc_structure_type)
  end
  memoize :structure_types

  private

  def default_measure_fields
    [:utility_rebate, :retrofit_lifetime].map do |api_name|
      CalcField.by_api_name!(api_name)
    end
  end

  def get_field(name)
    api_name = fields_mapping[name.to_sym] || name
    CalcField.by_api_name!(api_name)
  end
end
