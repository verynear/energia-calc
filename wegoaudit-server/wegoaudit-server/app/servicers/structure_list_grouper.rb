# This class is given a flattened list of structures. It returns a list
# of structures where any sampled structures of the same type, and with
# the same key characteristic (e.g. gallons per flush), have been combined
# into one composite structure.
#
class StructureListGrouper < Generic::Strict
  attr_accessor :measure_selection,
                :calc_structure_type,
                :calc_structures

  def initialize(measure_selection, calc_structure_type, calc_structures)
    @measure_selection = measure_selection
    @calc_structure_type = calc_structure_type
    @calc_structures = calc_structures
  end

  def grouped_structures
    structures_by_sample_group = calc_structures.group_by(&:sample_group_id)
    grouped_structures = structures_by_sample_group.delete(nil) || []

    structures_by_sample_group.each_with_object(grouped_structures) \
      do |(_sample_group_id, sg_structures), results|
      structures_by_field_value = sg_structures.group_by do |calc_structure|
        value = calc_structure.calc_field_values.fetch(grouping_field.to_s, {})['value']
        "#{calc_structure.calc_structure_type.api_name}_#{value}"
      end
      structures_by_field_value.each do |_field_value, fv_structures|
        results << combined_structures(fv_structures)
      end
    end
  end

  private

  def combined_structures(calc_structures)
    StructureCombiner.new(calc_structures).combined_structures
  end
  memoize :combined_structures

  def grouping_field
    measure_selection.structure_type_definition_for(calc_structure_type)
      .grouping_field_api_name
  end
  memoize :grouping_field
end
