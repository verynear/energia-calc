class SubstructureListViewCell < UITableViewCell
  include AppDelegateTools
  extend IB

  attr_accessor :substructure, :controller_delegate

  outlet :name, UILabel
  outlet :clone_button, UIButton
  outlet :link_button, UIButton

  def update(substructure = nil)
    self.substructure = substructure
    name.text = substructure.short_description
    clone_button.hidden = !can_clone?
    link_button.hidden = !can_link?
  end

  def clone
    controller_delegate.clone_substructure(substructure, self)
  end

  def link_pressed
    controller_delegate.link_substructure(substructure, self)
  end

  private

  def can_clone?
    can_edit_current_audit?
  end

  def can_link?
    can_edit_current_audit? &&
      building_substructure_type? &&
      !substructure.physical_structure.linked?
  end

  def building_substructure_type?
    substructure.structure_type.physical_structure_type == 'Building'
  end
end
