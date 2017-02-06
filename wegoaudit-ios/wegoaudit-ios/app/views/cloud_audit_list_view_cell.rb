class CloudAuditListViewCell < UITableViewCell
  extend IB

  attr_accessor :audit

  outlet :name, UILabel
  outlet :download_button, UIButton

  def download_pressed(sender)
    HandlerService.execute(params: audit, object_class: Audit)
    FullStructureDownloadService.execute!(structure_id: audit[:structure_id])
    download_button.hidden = true
  end

  def update(audit = nil)
    self.audit = audit
    name.text = audit[:name]
  end
end
