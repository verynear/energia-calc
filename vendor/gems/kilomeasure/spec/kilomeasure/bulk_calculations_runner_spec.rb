require 'spec_helper'

describe Kilomeasure::BulkCalculationsRunner do
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
  let(:formulas) { Kilomeasure::FormulasCollection.new([formula1, formula2]) }

  it 'returns a hash of results' do
    calculations_runner = described_class.new(
      formulas: formulas,
      inputs: { field1: 3, foo: 2, baz: 3 })

    expect(calculations_runner.results.results).to eq(formula1: 8, qux: 6)
  end

  it 'returns nil values and sets an error_hash if a formula does not resolve' do
    calculations_runner = described_class.new(
      formulas: formulas,
      inputs: { field1: 3, foo: 2 })

    calculations_set = calculations_runner.results
    expect(calculations_set.results).to eq(
      formula1: nil,
      qux: nil)

    expect(calculations_set.errors_hash)
      .to eq(formula1: [:qux], qux: [:baz])
  end
end
