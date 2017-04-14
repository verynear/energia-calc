# This class is given an array of Wegoaudit::Structure objects that need to be
# combined, and returns a composite structure.
#
class StructureCombiner < Generic::Strict
  attr_accessor :calc_structures

  def initialize(calc_structures)
    @calc_structures = calc_structures
  end

  def combined_structures
    return calc_structures.first if calc_structures.length == 1

    calc_structures.first.tap do |calc_structure|
      calc_structure.n_structures = n_structures_sum
      calc_structure.calc_field_values = combined_field_values
    end
  end

  private

  def combined_field_values
    structure_field_values = calc_structures.map(&:calc_field_values)
    FieldValuesCombiner.new(structure_field_values).combined_field_values
  end

  def n_structures_sum
    calc_structures.map(&:n_structures).reduce(0.0) { |sum, n| sum + n }.round
  end
end
