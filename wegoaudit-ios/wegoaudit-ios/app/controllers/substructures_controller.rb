class SubstructuresController < UITableViewController
  extend IB
  include BaseController

  attr_accessor :structure, :new_object_popover

  def viewDidLoad
    super
  end

  def substructure_map
    @substructure_map ||= SubstructureMap.new(structure)
  end

  def viewWillAppear(animated)
    super

    reload!

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

  # SubstructureCreationViewCell delegate
  def add_substructure(substructure_type, sender)
    new_substructure_controller = get_view_controller('newSubstructureController')
    new_substructure_controller.structure = self.structure
    new_substructure_controller.structure_type = substructure_type

    presentModalViewController(new_substructure_controller, animated: true)
  end

  def add_sample_group(substructure_type, sender)
    sample_controller = get_view_controller('newSampleGroupController')
    sample_controller.structure = self.structure
    sample_controller.structure_type = substructure_type

    presentModalViewController(sample_controller, animated: true)
  end

  def import_substructure(substructure_type, sender)
    search_controller = get_view_controller('substructureSearchController')
    search_controller.structure_type = substructure_type
    search_controller.structure = self.structure

    display_popover(search_controller, sender)
  end

  # SubstructureListViewCell delegate
  def clone_substructure(to_clone, sender)
    clone_controller = get_view_controller('cloneSubstructureController')
    clone_controller.substructure = to_clone

    display_popover(clone_controller, sender)
  end

  def link_substructure(structure_to_link, sender)
    search_controller = get_view_controller('substructureSearchController')
    search_controller.structure = structure_to_link
    search_controller.structure_type = structure_to_link.structure_type

    display_popover(search_controller, sender)
  end

  def reload!
    @substructure_map = nil
    substructure_map
    self.tableView.reloadData
  end

  private

  # UITableViewDelegate
  def tableView(tableView, editingStyleForRowAtIndexPath: indexPath)
    if indexPath.row == 0
      UITableViewCellEditingStyleNone
    else
      UITableViewCellEditingStyleDelete
    end
  end

  def tableView(tableView, canEditRowAtIndexPath: indexPath)
    if indexPath.row == 0
      false
    else
      true
    end
  end

  def tableView(tableView, commitEditingStyle: editingStyle,
                           forRowAtIndexPath: indexPath)
    unless indexPath.row == 0
      if editingStyle == UITableViewCellEditingStyleDelete
        decrementedIndexPath = adjustedIndexPath(indexPath)
        substructure = substructure_map.removeObjectAtIndexPath(decrementedIndexPath)

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
            if substructure.is_a?(SampleGroup)
              SampleGroupDestroyer.execute!(sample_group: substructure)
            else
              StructureDestroyer.execute!(structure: substructure)
            end
            tableView.deleteRowsAtIndexPaths([indexPath],
              withRowAnimation: UITableViewRowAnimationFade)
            cdq.save
          when :cancel
            self.tableView.editing = false
          end
        end
      end
    end
  end

  def numberOfSectionsInTableView(tableView)
    substructure_map.section_count
  end

  def tableView(tableView, numberOfRowsInSection: section)
    substructure_map.section(section).count + 1
  end

  def tableView(tableView, titleForHeaderInSection: section)
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    if indexPath.row == 0
      cell = tableView.dequeueReusableCellWithIdentifier('substructureCreationCell')

      cell.update(substructure_map.substructureForSection(indexPath.section))
      cell.controller_delegate = self
    else
      substructure = substructure_map.objectAtIndexPath(adjustedIndexPath(indexPath))

      if substructure.is_a?(SampleGroup)
        cell = tableView.dequeueReusableCellWithIdentifier('sampleGroupCell')
      else
        cell = tableView.dequeueReusableCellWithIdentifier('substructureCell')
        cell.controller_delegate = self
      end

      cell.update(substructure)
    end

    cell
  end

  def adjustedIndexPath(indexPath)
    NSIndexPath.indexPathForRow(indexPath.row - 1,
                                inSection: indexPath.section)
  end

  # Notification Handler
  def context_did_save(notification)
    reload!
  end

  def prepareForSegue(segue, sender: sender)
    case segue.identifier
    when 'structureTabBarSegue'
      segue.destinationViewController.prepare_tabs(sender.substructure.presenter)
    when 'sampleGroupSegue'
      segue.destinationViewController.prepare_tabs(sender.sample_group)
    end
  end
end
