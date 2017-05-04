# This class is given an array of Wegoaudit::Structure objects that need to be
# combined, and returns a composite structure.
#
class StructureCombiner < Generic::Strict
  attr_accessor :structures,
                :temp_structures

  def initialize(structures)
    @structures = structures
  end

  def combined_structures
    return structures.first if structures.length == 1

    structures.first.tap do |structure|
      structure.n_structures = n_structures_sum
      structure.field_values = combined_field_values
    end
  end

  private

  def combined_field_values
    structure_field_values = structures.map(&:field_values)
    FieldValuesCombiner.new(structure_field_values).combined_field_values
  end

  def n_structures_sum
    structures.map(&:n_structures).reduce(0.0) { |sum, n| sum + n }.round
  end
end
