class SampleGroupController < UITableViewController
  extend IB
  include AppDelegateTools
  include BaseController

  attr_accessor :sample_group

  def viewDidLoad
    super
    set_add_sample_button_state
  end

  def viewWillAppear(animated)
    super

    NSNotificationCenter.defaultCenter.addObserver(
      self,
      selector: 'context_did_save:',
      name: NSManagedObjectContextDidSaveNotification,
      object: nil)

    NSNotificationCenter.defaultCenter.addObserver(
      self,
      selector: 'dismiss_popover:',
      name: 'dismissPopover',
      object: nil)
  end

  def viewWillDisappear(animated)
    clear_notifications
    super
  end

  def dealloc
    clear_notifications
    super
  end

  def clear_notifications
    NSNotificationCenter.defaultCenter.removeObserver(
      self,
      name: NSManagedObjectContextDidSaveNotification)

    NSNotificationCenter.defaultCenter.removeObserver(
      self,
      name: 'dismissPopover')
  end

  # SampleListViewCell delegate
  def clone_substructure(to_clone, sender)
    clone_controller = get_view_controller('cloneSubstructureController')
    clone_controller.substructure = to_clone

    display_popover(clone_controller, sender)
  end

  private

  def substructures
    @substructures ||= sample_group.substructures.not_destroyed.to_a
  end

  # UITableViewDelegate
  def tableView(tableView, editingStyleForRowAtIndexPath: path)
    can_edit_current_audit? ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone
  end

  def tableView(tableView, canEditRowAtIndexPath: path)
    can_edit_current_audit?
  end

  def tableView(tableView, commitEditingStyle: editingStyle, forRowAtIndexPath: path)
    return unless can_edit_current_audit?

    substructure = substructures[path.row]
    message = "#{substructure.short_description} will be deleted immediately from the device."

    if substructure.has_been_uploaded?
      message << " It will be removed from the audit when the audit is uploaded to the server. This action can not be undone."
    end

    UIAlertView.alert("Delete #{substructure.short_description}",
                      message,
                      buttons: {
                        cancel: 'Cancel',
                        success: 'Delete'}) do |button|
      case button
      when :success
        @substructures = nil
        StructureDestroyer.execute!(structure: substructure)
        tableView.deleteRowsAtIndexPaths([path],
          withRowAnimation: UITableViewRowAnimationFade)
        cdq.save
      when :cancel
        self.tableView.editing = false
      end
    end
  end

  def tableView(tableView, numberOfRowsInSection: section)
    substructures.length
  end

  def tableView(tableView, cellForRowAtIndexPath: path)
    substructure = substructures[path.row]
    cell = tableView.dequeueReusableCellWithIdentifier('sampleCell')
    cell.controller_delegate = self
    cell.update(substructure)
    cell
  end

  # Notification Handler
  def context_did_save(notification)
    @substructures = nil
    substructures
    set_add_sample_button_state
    self.tableView.reloadData
  end

  def prepareForSegue(segue, sender: sender)
    case segue.identifier
    when 'structureTabBarSegue'
      segue.destinationViewController.prepare_tabs(sender.substructure.presenter)
    end
  end

  def set_add_sample_button_state
    parentViewController.set_add_sample_button_state
  end
end
