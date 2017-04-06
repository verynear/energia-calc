require 'fattr'

class MeasureDefinitionLoader < Generic::Strict

  fattrs :data_path,
         :name

  attr_reader :data,
              :measure_definition

  def initialize(*)
    super
    raise 'data_path' unless data_path
  end

  def each_measure_definition_from_file
    Dir["#{data_path}/measures/*.yml"].each do |file_name|
      yield load_from_file(File.basename(file_name, '.yml'))
    end
  end

  def load_from_data(name, data)
    kilomeasure_measure = Kilomeasure.get_measure(name)
    MeasureDefinition.new(
      name: name,
      local_definition: data,
      kilomeasure_measure: kilomeasure_measure)
  end

  def load_from_file(name)
    @data = measure_file_contents(name)
    load_from_data(name, @data)
  end

  private

  def measure_file_contents(name)
    measure_file = File.join(data_path, "#{name}.yml")
    YAML.load_file(measure_file).deep_symbolize_keys
  rescue Errno::ENOENT
    {}
  end
end
