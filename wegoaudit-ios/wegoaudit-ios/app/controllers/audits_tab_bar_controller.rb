class AuditsTabBarController < UITabBarController
  extend IB
  include BaseController

  attr_accessor :new_object_popover

  def viewDidLoad
    super

    self.title = "#{tabBar.items.first.title} Audits"
  end

  def tabBar(tabBar, didSelectItem: item)
    self.title = "#{item.title} Audits"
  end

  def open_new_audit
    push_view_controller(NewAuditController.alloc.initController)
  end
end
