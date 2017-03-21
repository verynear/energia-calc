require 'singleton'

module Kilomeasure
  class MeasuresRegistry
    include Singleton

    attr_accessor :loader

    def self.get(name)
      instance.get(name)
    end

    def self.load(data_path: nil)
      instance.loader.data_path = data_path if data_path
      instance.load_measures
    end

    def self.reset
      instance.reset
    end

    def self.set(name, data)
      instance.set(name, data)
    end

    def initialize(**options)
      construct(options)
    end

    def all
      load_measures
      @measures_lookup.select { |_key, value| value.present? }.values
    end

    def get(name)
      @measures_lookup[name] ||= load_measure(name)
    end

    def has_measure?(name)
      @measures_lookup.has_key?(name)
    end

    def load_measures
      loader.each_measure_from_file do |measure|
        @measures_lookup[measure.name] = measure
      end
    end

    def loaded?
      !@measures_lookup.empty?
    end

    def names
      all.map(&:name)
    end

    def reset
      construct
    end

    def set(name, data)
      @measures_lookup[name] = loader.load_from_data(name, data)
    end

    private

    # For reuse in reset method
    def construct(loader: nil)
      loader ||= MeasureLoader.new
      @loader = loader
      @measures_lookup = HashWithIndifferentAccess.new
    end

    def load_measure(name)
      loader.load_from_file(name)
    end
  end
end
