require 'kilomeasure/formulas_collection'

describe Kilomeasure::FormulasCollection do
  describe '#get_by_name' do
    let(:formula1) do
      instance_double(Kilomeasure::Formula, name: :foo)
    end
    let(:formula2) do
      instance_double(Kilomeasure::Formula, name: :bar)
    end
    let(:formula3) do
      instance_double(Kilomeasure::Formula, name: :baz)
    end
    let(:formulas) { [formula1, formula2, formula3] }

    it 'returns the formula by name' do
      collection = described_class.new(formulas)
      expect(collection.get_by_name(:bar)).to eq(formula2)
    end
  end
end
