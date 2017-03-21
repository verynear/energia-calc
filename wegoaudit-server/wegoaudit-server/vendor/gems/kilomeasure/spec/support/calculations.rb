module CalculationSupport
  def retrofit_calculation(field, strict: true, **options)
    calculations_set = measure.run_retrofit_calculations(
      strict: strict,
      **options)
    expect(calculations_set.errors_hash[field]).to be_nil
    calculations_set.get_calculation_value(field)
  end

  def should_get_component_field_value(field, inputs, expected_value)
    value = value_for_calculation(field, inputs)
    expect(value).to be_within(0.1).of(expected_value)
    @example.metadata[:description] = "gets #{field}" if @example
  end

  def should_get_cost_of_measure(value, **options)
    should_get_field_value(:cost_of_measure, value, options)
  end

  def should_get_cost_savings(value, **options)
    should_get_field_value(:annual_cost_savings, value, options)
  end

  def should_get_electric_savings(value, **options)
    should_get_field_value(:annual_electric_savings, value, options)
  end

  def should_get_field_value(field, expected_value, **options)
    options.merge!(
      before_inputs: before_inputs,
      after_inputs: after_inputs,
      shared_inputs: shared_inputs)
    value = retrofit_calculation(field, options)
    if expected_value.nil?
      expect(value).to be_nil
    else
      expect(value).to be_within(0.1).of(expected_value)
    end
    @example.metadata[:description] = "gets #{field}" if @example
  end

  def should_get_gas_savings(value, **options)
    should_get_field_value(:annual_gas_savings, value, options)
  end

  def should_get_oil_savings(value, **options)
    should_get_field_value(:annual_oil_savings, value, options)
  end

  def should_get_water_savings(value, **options)
    should_get_field_value(:annual_water_savings, value, options)
  end

  def should_get_years_to_payback(value, **options)
    should_get_field_value(:years_to_payback, value, options)
  end

  def value_for_calculation(field, inputs)
    inputs = Kilomeasure::InputsFormatter.new(
      inputs: inputs,
      measure: measure).inputs
    calculations_set = measure.run_calculations(
      inputs: inputs)
    calculations_set[field]
  end
end
