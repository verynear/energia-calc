module Kilomeasure
  # Loads a measure definition and the formulas associated with it.
  #
  class MeasureLoader < ObjectBase
    fattrs :data_path

    attr_reader :data,
                :measure

    def initialize(*)
      super
      self.data_path ||= DATA_PATH
    end

    def each_measure_from_file
      Dir["#{data_path}/measures/*.yml"].each do |file_name|
        yield load_from_file(File.basename(file_name, '.yml'))
      end
    end

    def load_from_data(name, data)
      formulas = FormulasCollection.new(build_formulas(data))
      output_formulas = FormulasCollection.new(build_output_formulas(data))
      field_definitions = data.fetch(:field_definitions, {})
      lookups = data.fetch(:lookups, {})
      inputs_only = data.fetch(:inputs_only, false)
      inputs = build_inputs(data)
      defaults = data.fetch(:defaults, {})
      data_types = data.fetch(:data_types, [])

      options = {
        field_definitions: field_definitions,
        name: name,
        formulas: formulas,
        output_formulas: output_formulas,
        defaults: defaults,
        lookups: lookups,
        inputs: inputs,
        inputs_only: inputs_only,
        data_types: data_types
      }

      Measure.new(options)
    end

    def load_from_file(name)
      @data = measure_file_contents(name)
      load_from_data(name, data)
    end

    private

    def build_formulas(data)
      data_types = data.fetch(:data_types, [])
      default_formulas = DEFAULT_FORMULAS.select do |formula_name, _formula|
        if formula_name =~ DATA_TYPES_REGEXP
          data_type = DATA_TYPES_REGEXP.match(formula_name)[1]
          next false unless data_types.include?(data_type.to_s)
        end
        true
      end

      formulas = default_formulas.merge(
        data.fetch(:formulas, {}))
      formulas.map do |name, formula|
        Formula.new(name: name, expression: formula)
      end + formulas_from_lookups(data)
    end

    def build_inputs(data)
      field_names = data.fetch(:inputs, [])
      field_names.map do |field_name|
        Input.new(name: field_name)
      end
    end

    def build_output_formulas(data)
      data_types = data.fetch(:data_types, [])
      default_output_formulas = DEFAULT_OUTPUT_FORMULAS.select do |formula_name, _formula|
        if formula_name =~ DATA_TYPES_REGEXP
          data_type = DATA_TYPES_REGEXP.match(formula_name)[1]
          next false unless data_types.include?(data_type.to_s)
        end
        true
      end

      formulas = default_output_formulas.merge(
        data.fetch(:output_formulas, {})
      )
      formulas.map do |name, expression|
        Formula.new(name: name, expression: expression)
      end
    end

    def expression_proc
      lambda do |input_name, pairs|
        key, value = pairs.shift
        if key
          next_condition = expression_proc.call(input_name, pairs)
        else
          return "'finally'"
        end

        <<-EXPRESSION.strip_heredoc
          IF(#{input_name} = #{key.is_a?(Numeric) ? key : "'#{key}'"},
             #{value},
             #{next_condition})
        EXPRESSION
      end
    end

    def formulas_from_lookups(data)
      data.fetch(:lookups, {}).map do |name, options|
        lookup = options.fetch(:lookup).with_indifferent_access
        input_name = options.fetch(:input_name).to_sym

        pairs = lookup.to_a
        expression = expression_proc.call(input_name, pairs)

        Formula.new(
          expression: expression,
          name: name,
          additional_dependencies: [input_name])
      end
    end

    private

    def measure_file_contents(name)
      measure_file = File.join(data_path, 'measures', "#{name}.yml")
      YAML.load_file(measure_file).deep_symbolize_keys
    rescue Errno::ENOENT
      {}
    end
  end
end
