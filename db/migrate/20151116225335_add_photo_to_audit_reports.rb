class AddPhotoToAuditReports < ActiveRecord::Migration
  def change
    add_column :audit_reports, :wegoaudit_photo_id, :string
  end
end
