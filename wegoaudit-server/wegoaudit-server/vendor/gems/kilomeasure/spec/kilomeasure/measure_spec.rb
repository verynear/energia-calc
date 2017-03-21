require 'spec_helper'

describe Kilomeasure::Measure do
  describe '#defaults' do
    it 'is an empty hash by default' do
      expect(described_class.new.defaults).to eq({})
    end

    it 'has its keys symbolized' do
      measure = described_class.new(defaults: { 'blah' => 1 })
      expect(measure.defaults).to eq(blah: 1)
    end
  end

  specify '#run_calculations calls BulkCalculationRunner' do
    calculations_set = instance_double(Kilomeasure::CalculationsSet)
    calculation_runner = instance_double(
      Kilomeasure::BulkCalculationsRunner,
      results: calculations_set)
    formulas = Kilomeasure::FormulasCollection.new
    measure = described_class.new(formulas: formulas)
    allow(Kilomeasure::BulkCalculationsRunner)
      .to receive(:new)
      .and_return(calculation_runner)

    expect(
      measure.run_calculations(
        inputs: { foo: 3 })
    ).to eq(calculations_set)

    expect(calculation_runner).to have_received(:results)
    expect(Kilomeasure::BulkCalculationsRunner)
      .to have_received(:new)
      .with(measure: measure,
            formulas: formulas,
            inputs: { foo: 3 })
  end

  specify 'fields returns a list of fields' do
    measure = described_class.new(
      inputs: [:field1, :field2, :field3])

    expect(measure.inputs).to eq([:field1, :field2, :field3])
  end
end
