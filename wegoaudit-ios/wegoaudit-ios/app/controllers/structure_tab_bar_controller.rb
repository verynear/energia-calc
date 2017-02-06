class StructureTabBarController < UITabBarController
  extend IB
  include AppDelegateTools

  attr_accessor :structure

  def loadView
    super
  end

  def viewDidLoad
    super

    self.title = structure.name
  end

  def viewWillAppear(animated)
    super
  end

  def viewWillDisappear(animated)
    super
  end

  def prepare_tabs(struct)
    @structure = struct

    self.viewControllers.each_with_index do |controller, index|
      controller.structure = @structure if controller.respond_to?(:structure=)
    end

    remove_substructures_tab unless structure.can_have_substructures?
  end

  def dealloc
    super
  end

  private

  def remove_substructures_tab
    tabs = self.viewControllers
    tabs.shift
    self.viewControllers = tabs
  end
end
