class SettingsController < UITableViewController
  extend IB
  include BaseController

  outlet :displayed_name, UILabel
  outlet :username, UILabel
  outlet :wegoaudit_version, UILabel

  def viewDidLoad
    super

    self.displayed_name.text = current_user.full_name(true)
    self.username.text = current_user.username
    self.wegoaudit_version.text = current_version
  end

  def dismiss(sender)
    dismissViewControllerAnimated(true, completion: nil)
  end

  def tableView(tableView, didSelectRowAtIndexPath: index_path)
    dismissViewControllerAnimated(true, completion: nil)
    app_delegate.main_nav_controller.popViewControllerAnimated(false)
  end

  private

  def current_version
    NSBundle.mainBundle.infoDictionary['CFBundleVersion']
  end
end
