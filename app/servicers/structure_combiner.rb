# This class is given an array of Wegoaudit::Structure objects that need to be
# combined, and returns a composite structure.
#
class StructureCombiner < Generic::Strict
  attr_accessor :temp_structures

  def initialize(temp_structures)
    @temp_structures = temp_structures
  end

  def combined_structures
    return temp_structures.first if temp_structures.length == 1

    temp_structures.first.tap do |temp_structure|
      temp_structure.n_structures = n_structures_sum
      temp_structure.field_values = combined_field_values
    end
  end

  private

  def combined_field_values
    structure_field_values = temp_structures.map(&:field_values)
    FieldValuesCombiner.new(structure_field_values).combined_field_values
  end

  def n_structures_sum
    temp_structures.map(&:n_structures).reduce(0.0) { |sum, n| sum + n }.round
  end
end
