require 'spec_helper'

describe Kilomeasure::MeasureLoader do
  let(:loader) { described_class.new(data_path: 'path') }

  describe '#load_from_file' do
    it 'loads a measure from a file' do
      allow(YAML).to receive(:load_file).with('path/measures/measure.yml')
        .and_return(
          inputs: [:field1]
        )

      measure = loader.load_from_file('measure')

      expect(measure.inputs.first.name).to eq(:field1)
      expect(measure.name).to eq('measure')
    end

    it 'loads an empty measure if a file does not exist' do
      measure = loader.load_from_file('measure')

      expect(measure.inputs.empty?).to eq(true)
      expect(measure.name).to eq('measure')
    end
  end

  describe '#load_from_data' do
    it 'sets a name on the measure' do
      measure = loader.load_from_data('measure', {})

      expect(measure.name).to eq('measure')
    end

    it 'creates a formulas collection on the measure' do
      measure = loader.load_from_data(
        'measure',
        formulas: {
          one_plus_one: '1 + 1'
        }
      )

      expect(measure.formulas.get_by_name(:one_plus_one))
        .to be_a(Kilomeasure::Formula)
    end
  end

  specify '#each_measure_from_file yields each measure in a folder' do
    measure1 = instance_double(Kilomeasure::Measure)
    measure2 = instance_double(Kilomeasure::Measure)
    allow(Kilomeasure::Measure).to receive(:new)
      .and_return(measure1, measure2)

    loader.data_path = 'path'
    allow(Dir).to receive(:[]).with('path/measures/*.yml')
      .and_return(%w[file1 file2])

    expect { |b| loader.each_measure_from_file(&b) }
      .to yield_successive_args(measure1, measure2)
  end
end
