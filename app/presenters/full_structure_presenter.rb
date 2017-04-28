class FullStructurePresenter < Decorator
  def as_json(options = nil)
    h = attributes
    if physical_structure.present?
      h['physical_structure'] = physical_structure.attributes
      h['name'] = physical_structure.name
    end
    h['substructures'] = substructures_array
    h['sample_groups'] = sample_groups_array
    h['field_values'] = field_values_array
    h
  end

  private

  def substructures_array
    substructures.map do |substructure|
      FullStructurePresenter.new(substructure).as_json
    end
  end

  def sample_groups_array
    sample_groups.map do |sample_group|
      FullSampleGroupPresenter.new(sample_group).as_json
    end
  end

  def field_values_array
    audit_field_values.map do |audit_field_value|
      audit_field_value.as_json
    end
  end
end
