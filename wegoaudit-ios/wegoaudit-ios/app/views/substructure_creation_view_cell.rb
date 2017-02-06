class SubstructureCreationViewCell < UITableViewCell
  SAMPLEABLE_TYPES = [
    'Apartment',
    'Common Area'
  ]

  include AppDelegateTools
  extend IB

  attr_accessor :substructure_type, :controller_delegate

  outlet :substructure_type_name, UILabel
  outlet :add_button, UIButton
  outlet :import_button, UIButton
  outlet :sample_group_button, UIButton

  def update(substructure_type = nil)
    self.substructure_type = substructure_type
    substructure_type_name.text = substructure_type.name

    add_button.hidden = !can_add?
    import_button.hidden = !can_import?
    sample_group_button.hidden = !can_sample?
  end

  def add
    controller_delegate.add_substructure(substructure_type, self)
  end

  def import
    controller_delegate.import_substructure(substructure_type, self)
  end

  def add_sample_group
    controller_delegate.add_sample_group(substructure_type, self)
  end

  private

  def building_substructure_type?
    substructure_type.physical_structure_type == 'Building'
  end

  def can_add?
    can_edit_current_audit? && !can_sample?
  end

  def can_import?
    can_edit_current_audit? && building_substructure_type?
  end

  def can_sample?
    can_edit_current_audit? &&
      SAMPLEABLE_TYPES.include?(substructure_type_name.text)
  end
end
