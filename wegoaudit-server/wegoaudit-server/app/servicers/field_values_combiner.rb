# This class is given an array of field_values hashes, one for each
# Wegoaudit::Structure object that needs to be combined, and returns
# a composite field_values hash.
#
class FieldValuesCombiner < Generic::Strict
  attr_accessor :structure_field_values

  def initialize(structure_field_values)
    @structure_field_values = structure_field_values
  end

  def combined_field_values
    composite_fields = field_keys.each_with_object({}) do |field_key, composite|
      calc_field_values = field_values_for_key(field_key)

      unless can_average?(calc_field_values) && calc_field_values.length > 1
        composite[field_key] = calc_field_values.first
        next
      end

      average_value = average(converted_values(calc_field_values))
      if value_type(calc_field_values) == 'integer'
        average_value = average_value.to_i
      end

      calc_field_value = calc_field_values.first
      calc_field_value['value'] = average_value

      composite[field_key] = calc_field_value
    end

    HashWithIndifferentAccess.new(composite_fields)
  end

  private

  def average(values)
    values_sum = values.reduce(0.0) { |sum, value| sum + value }
    values_sum / values.length.to_f
  end

  def can_average?(calc_field_values)
    %w[decimal integer].include?(value_type(calc_field_values))
  end

  def converted_values(calc_field_values)
    type = calc_field_values.first['value_type']
    raw_values = calc_field_values.map { |calc_field_value| calc_field_value['value'] }

    if type == 'decimal'
      raw_values.map(&:to_f)
    elsif type == 'integer'
      raw_values.map(&:to_i)
    else
      raw_values
    end
  end

  def field_keys
    structure_field_values.flat_map(&:keys).uniq
  end

  def field_values_for_key(key)
    calc_fields = structure_field_values.map { |sfv| sfv[key] }
    calc_fields.compact
  end

  def value_type(calc_field_values)
    calc_field_values.first['value_type']
  end
end
