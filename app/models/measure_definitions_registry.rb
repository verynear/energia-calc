require 'singleton'

class MeasureDefinitionsRegistry
  include Singleton

  attr_accessor :loader

  @default_data_path = Rails.root.join('data', 'measures')
  @data_path = @default_data_path

  def self.add_definition(name, data)
    set(name, data)
  end

  def self.data_path
    @data_path
  end

  def self.data_path=(path)
    @data_path = path
  end

  def self.get(api_name)
    instance.get(api_name)
  end

  def self.load(data_path: nil)
    instance.loader.data_path = data_path if data_path
    instance.load_measure_definitions
  end

  def self.reset
    instance.reset
  end

  def self.reset_data_path
    data_path = @default_data_path
    instance.loader.data_path = data_path
  end

  def self.set(name, data)
    instance.set(name, data)
  end

  def initialize(**options)
    construct(options)
  end

  def all
    load_measure_definitions
    @measure_definitions_lookup.select { |_key, value| value.present? }.values
  end

  def get(name)
    @measure_definitions_lookup[name.to_sym] ||= load_measure(name.to_sym)
  end

  def has_measure?(name)
    @measure_definitions_lookup.has_key?(name.to_sym)
  end

  def load_measure_definitions
    loader.each_measure_definition_from_file do |measure|
      @measure_definitions_lookup[measure.name.to_sym] = measure
    end
  end

  def loaded?
    !@measure_definitions_lookup.empty?
  end

  def names
    all.map(&:name)
  end

  def reset
    construct
  end

  def set(name, data)
    @measure_definitions_lookup[name.to_sym] = loader.load_from_data(name, data)
  end

  private

  # For reuse in reset method
  def construct(loader: nil)
    loader ||= MeasureDefinitionLoader.new(data_path: self.class.data_path)
    @loader = loader
    @measure_definitions_lookup = HashWithIndifferentAccess.new
  end

  def load_measure(name)
    loader.load_from_file(name)
  end
end
