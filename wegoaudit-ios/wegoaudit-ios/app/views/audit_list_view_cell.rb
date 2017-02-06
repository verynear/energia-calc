class AuditListViewCell < UITableViewCell
  include AppDelegateTools

  extend IB

  attr_accessor :audit, :controller_delegate

  outlet :name, UILabel
  outlet :user, UILabel
  outlet :date, UILabel
  outlet :lock_image, UIImageView
  outlet :upload_button, UIButton
  outlet :clone_button, UIButton

  def update(audit = nil)
    self.audit = audit
    name.text = audit.name
    if audit.is_locked?
      lock_image.hidden = false
      lock_image.setAccessibilityIdentifier('locked')
      upload_button.hidden = false if audit.locked_by == current_user.id
    else
      lock_image.hidden = true
      lock_image.setAccessibilityIdentifier('unlocked')
      upload_button.hidden = true
    end
    user.text = audit.user.full_name(true)
    date.text = audit.performed_on.strftime("%d %b %y")
  end

  def is_locked?
    archive_image.accessibilityIdentifier == 'locked'
  end

  def upload_pressed(sender)
    controller_delegate.upload_audit(audit)
  end

  def clone_pressed(sender)
    controller_delegate.clone_audit(audit, self)
  end
end
