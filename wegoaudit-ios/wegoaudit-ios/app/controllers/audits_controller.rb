class AuditsController < UITableViewController
  extend IB
  include ActivityNotifier
  include BaseController

  attr_accessor :audits, :new_object_popover

  def viewDidAppear(animated)
    super

    tableView.reloadData
  end

  def viewWillAppear(animated)
    super

    app_delegate.current_audit = nil

    reload_audits

    NSNotificationCenter.defaultCenter.addObserver(
      self,
      selector: 'context_did_save:',
      name: NSManagedObjectContextDidSaveNotification,
      object: nil)

    NSNotificationCenter.defaultCenter.addObserver(
      self,
      selector: 'dismiss_popover:',
      name: 'dismissCloneAuditPopover',
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
      name: 'dismissCloneAuditPopover')
  end

  # audit delegate
  def upload_audit(audit)
    start_activity('Uploading...', :black)
    AuditUploadService.execute!(audit: audit)
  end

  def clone_audit(audit, sender)
    clone_controller = get_view_controller('cloneAuditController')
    clone_controller.audit = audit

    display_popover(clone_controller, sender)
  end

  def reload_audits
    @audits = nil
    audits
  end

  private

  def audits
    @audits ||= Audit.list_all.to_a
  end

  # UITableViewDelegate
  def tableView(tableView, editingStyleForRowAtIndexPath: indexPath)
    UITableViewCellEditingStyleDelete
  end

  def tableView(tableView, canEditRowAtIndexPath: indexPath)
    true
  end

  def tableView(tableView, commitEditingStyle: editingStyle,
                           forRowAtIndexPath: indexPath)
    UIAlertView.alert('Delete Audit',
                      'Deleting an audit will delete all associated structures and photos from this device. It will not remove the audit from your account on the server.',
                      buttons: {
                        cancel: 'Cancel',
                        success: 'Delete'}) do |button|
      case button
      when :success
        audit = audit_at_index_path(indexPath)
        AuditDestroyer.execute!(audit: audit)

        AuditUnlockService.execute!(audit: audit, user: current_user)
        cdq.save
      end
    end
  end

  def audit_at_index_path(indexPath)
    audits[indexPath.row]
  end

  def tableView(tableView, numberOfRowsInSection: section)
    audits.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= 'auditCell'
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)

    cell.update(audit_at_index_path(indexPath))
    cell.controller_delegate = self

    return cell
  end

  # Notification Handler
  def context_did_save(notification)
    reload_audits
    tableView.reloadData
    stop_activity(success: 'Upload finished!')
  end

  def prepareForSegue(segue, sender: sender)
    case segue.identifier
    when 'auditTabBarSegue'
      audit_tab_bar_controller = segue.destinationViewController
      audit_tab_bar_controller.structure = sender.audit.structure
      app_delegate.current_audit = sender.audit

      AuditLockService.execute!(audit: current_audit, user: current_user)

      structure_presenter = StructureDetailPresenter.new(sender.audit.structure)
      audit_tab_bar_controller.viewControllers.each_with_index do |controller, index|
        controller.structure = structure_presenter if controller.respond_to?(:structure=)
      end
    end
  end
end
