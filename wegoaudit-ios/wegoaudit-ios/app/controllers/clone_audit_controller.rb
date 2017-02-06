class CloneAuditController < UIViewController
  extend IB
  include BaseController

  attr_accessor :audit

  outlet :audit_type, UILabel
  outlet :audit_name, UILabel
  outlet :name, UITextField
  outlet :performed_on, UIDatePicker

  outlet :cancel_button, UIBarButtonItem
  outlet :clone_audit_button, UIBarButtonItem

  def viewDidLoad
    super

    @audit_types = AuditType.where(active: true).sort_by(:name)

    self.title = 'Clone Audit'

    self.audit_type.text = audit.audit_type.name
    self.audit_name.text = audit.name
    self.name.text = audit.name

    self.cancel_button.target = self
    self.cancel_button.action = 'cancel:'
    self.clone_audit_button.target = self
    self.clone_audit_button.action = 'clone_audit:'
  end

  def numberOfComponentsInPickerView(pickerView)
    1
  end

  def pickerView(pickerView, numberOfRowsInComponent: component)
    @audit_types.count
  end

  def pickerView(pickerView, titleForRow: index, forComponent: component)
    @audit_types[index].name
  end

  def clone_audit(sender)
    service = StructureCloneService.new(structure: audit.structure,
                                        params: { name: self.name.text })
    service.execute
    params = {
      name: self.name.text,
      performed_on: performed_on_date,
      user_id: current_user.id,
      locked_by: current_user.id,
      structure_id: service.cloned_structure.id,
      user_id: current_user.id,
    }
    cloned_audit = audit.clone(params)

    cdq.save
    close_popover
  end

  def performed_on_date
    time = self.performed_on.date
    Time.mktime(time.year, time.month, time.day)
  end

  def cancel(sender)
    close_popover
  end

  def close_popover
    NSNotificationCenter
      .defaultCenter
      .postNotificationName('dismissCloneAuditPopover', object: self)
  end
end
