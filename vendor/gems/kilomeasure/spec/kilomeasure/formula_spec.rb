require 'kilomeasure/formula'

describe Kilomeasure::Formula do
  describe '#run' do
    it 'calculates an expression' do
      formula = described_class.new(name: :foo, expression: '1 + 1')
      formula.run
      expect(formula.value).to eq(2)
    end

    it 'substitutes provided inputs' do
      formula = described_class.new(name: :foo, expression: 'apple + banana')
      formula.run(apple: 1, banana: 2)
      expect(formula.value).to eq(3)
    end

    it 'raises an exception if a dependency is missing' do
      formula = described_class.new(name: :foo, expression: 'apple + banana')
      expect { formula.run(apple: 1) }
        .to raise_error(ArgumentError, 'Missing required inputs [:banana]')
    end
  end

  describe '#dependencies' do
    it 'lists out variable names for formula' do
      formula = described_class.new(name: :foo, expression: 'apple + banana')
      expect(formula.dependencies).to eq([:apple, :banana])
    end
  end
end
