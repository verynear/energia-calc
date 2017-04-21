require 'spec_helper'

describe Kilomeasure::InputsValidator do
  let(:formula1) do
    Kilomeasure::Formula.new(
      name: :formula1,
      expression: 'foo + qux')
  end
  let(:formula2) do
    Kilomeasure::Formula.new(
      name: :qux,
      expression: 'baz + field1')
  end
  let!(:formulas) { Kilomeasure::FormulasCollection.new([formula1, formula2]) }
  let!(:output_formulas) { Kilomeasure::FormulasCollection.new }
  let!(:measure) do
    Kilomeasure::Measure.new(
      formulas: formulas,
      output_formulas: output_formulas,
      inputs: [
        Kilomeasure::Input.new(name: :field1),
        Kilomeasure::Input.new(name: :baz),
        Kilomeasure::Input.new(name: :foo)]
    )
  end

  describe '.validate' do
    it 'does not add an error if a field uses a valid option' do
      measure.field_definitions = { field1: { options: ['foo'] } }

      errors = described_class.validate(
        measure: measure,
        inputs: { field1: 'foo' })

      expect(errors).to be_empty
    end

    it "adds an error if a field uses an option that's not available" do
      allow(measure).to receive(:field_definitions)
        .and_return(field1: { options: ['foo'] })

      errors = described_class.validate(
        measure: measure,
        inputs: { field1: 'bar' })

      expect(errors).to eq(field1: ['Invalid option bar for field1'])
    end

    it "adds an error if an input is passed that's not expected" do
      errors = described_class.validate(
        measure: measure,
        strict: true,
        inputs: { field1: 2, field3: 3 })

      expect(errors).to eq(field3: ['Unknown input field3'])
    end

    # it 'adds an error if an input is listed but not used' do
    #  allow(measure).to receive(:formulas)
    #    .and_return(Kilomeasure::FormulasCollection.new([formula1]))
    #  errors = described_class.validate(
    #    measure: measure,
    #    inputs: { field1: 3 })
    #
    #  expect(errors).to eq(['Unused input field1', 'Unused input baz'])
    # end
  end
end
