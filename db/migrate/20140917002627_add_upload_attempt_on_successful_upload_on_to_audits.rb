class AddUploadAttemptOnSuccessfulUploadOnToAudits < ActiveRecord::Migration
  def change
    add_column :audits, :upload_attempt_on, :datetime
    add_column :audits, :successful_upload_on, :datetime
  end
end
