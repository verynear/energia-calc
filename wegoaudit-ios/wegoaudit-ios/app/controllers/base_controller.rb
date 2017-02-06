module BaseController
  include AppDelegateTools

  def get_and_push_view_controller(controller_name)
    push_view_controller(get_view_controller(controller_name))
  end

  def push_view_controller(controller)
    self.navigationController.pushViewController(controller, animated: true)
  end

  def get_view_controller(controller_name)
    app_delegate.get_view_controller(controller_name)
  end

  def display_popover(controller, sender)
    @new_object_popover = UIPopoverController.alloc
      .initWithContentViewController(controller)
    @new_object_popover.presentPopoverFromRect(sender.frame,
      inView: self.view,
      permittedArrowDirections: UIPopoverArrowDirectionAny,
      animated: true)
  end

  def dismiss_popover(notification)
    @new_object_popover.dismissPopoverAnimated(true)
  end
end
