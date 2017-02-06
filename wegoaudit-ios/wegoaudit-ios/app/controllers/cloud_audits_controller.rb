class CloudAuditsController < UITableViewController
  include AppDelegateTools
  include BaseController

  def viewDidLoad
    super

    tableView.allowsSelection = false
  end

  def viewDidAppear(animated)
    reload_audits!
    super
  end

  def audits
    @audits ||= []
  end

  def audits=(audits)
    @audits = audits
    tableView.reloadData
    @audits
  end

  def tableView(tableView, cellForRowAtIndexPath: path)
    @reuseIdentifier ||= 'cloudAudit'

    tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier).tap do |cell|
      audit = audits[path.row]
      cell.update(audit)
      cell.download_button.hidden = device_has_audit?(audit[:id])
    end
  end

  def tableView(tableView, numberOfRowsInSection: section)
    audits.length
  end

  def reload_audits!
    @device_audits = nil
    load_audits
    tableView.reloadData
  end

  private

  def load_audits
    BW::NetworkIndicator.show

    client.get("audits") do |result|
      if result.success?
        self.audits = result.object.sort_by {|a| a[:name] }
      else
        self.audits = []
      end
    end

    BW::NetworkIndicator.hide
  end

  def device_audits
    @device_audits ||= Audit.all.to_a.map(&:id).map(&:downcase)
  end

  def device_has_audit?(audit_id)
    device_audits.include?(audit_id)
  end
end
