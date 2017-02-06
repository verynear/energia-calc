class SampleGroupTabBarController < UITabBarController
  extend IB
  include BaseController

  attr_accessor :sample_group

  def loadView
    super
  end

  def viewDidLoad
    super

    self.title = sample_group.name
  end

  def open_new_sample_modal
    new_sample_controller = get_view_controller('newSampleController')
    new_sample_controller.sample_group = sample_group
    presentModalViewController(new_sample_controller, animated: true)
  end

  def prepare_tabs(group)
    self.sample_group = group

    self.viewControllers.each_with_index do |controller, index|
      controller.sample_group = group if controller.respond_to?(:sample_group=)
    end
  end

  def set_add_sample_button_state
    navigationItem.rightBarButtonItem.enabled = sample_group.can_add_samples?
  end
end
