require 'spec_helper'

describe Kilomeasure::MeasuresRegistry do
  let(:loader) do
    instance_double(
      Kilomeasure::MeasureLoader,
      load_from_data: nil,
      load_from_file: nil)
  end
  let(:registry) { described_class.send(:new, loader: loader) }

  specify '#set asks MeasureLoader to add a measure' do
    registry.set('measure', :data)

    expect(loader).to have_received(:load_from_data).with('measure', :data)
  end

  specify '#get asks MeasureLoader for a measure' do
    allow(loader).to receive(:load_from_file).and_return(:measure)

    expect(registry.get('measure')).to eq(:measure)
  end

  describe '#has_measure?' do
    it 'is false by default' do
      expect(registry.has_measure?('something')).to eq(false)
    end

    it 'is true when a measure is set' do
      registry.set('measure', {})
      expect(registry.has_measure?('measure')).to eq(true)
    end
  end

  describe '#load_measures' do
    before do
      allow(loader).to receive(:each_measure_from_file)
        .and_yield(instance_double(Kilomeasure::Measure, name: 'measure1'))
        .and_yield(instance_double(Kilomeasure::Measure, name: 'measure2'))
    end

    it 'loads each file name that is passed' do
      registry.load_measures

      expect(registry.has_measure?('measure1')).to eq(true)
      expect(registry.has_measure?('measure2')).to eq(true)
      expect(registry.has_measure?('measure3')).to eq(false)
    end
  end

  specify '#reset removes all measures' do
    registry.set('measure', {})
    expect(registry.has_measure?('measure')).to eq(true)

    registry.reset

    expect(registry.has_measure?('measure')).to eq(false)
  end
end
