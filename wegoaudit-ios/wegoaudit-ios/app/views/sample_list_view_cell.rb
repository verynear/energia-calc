class SampleListViewCell < UITableViewCell
  include AppDelegateTools
  extend IB

  attr_accessor :controller_delegate,
                :substructure

  outlet :name, UILabel
  outlet :clone_button, UIButton

  def update(substructure = nil)
    self.substructure = substructure
    name.text = substructure.name
    clone_button.hidden = !can_clone?
  end

  def clone_pressed
    controller_delegate.clone_substructure(substructure, self)
  end

  private

  def can_clone?
    can_edit_current_audit?
  end
end
