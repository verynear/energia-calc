class AddOrganizationIds < ActiveRecord::Migration
  def change
    add_column :audit_reports, :organization_id, :uuid
    add_column :report_templates, :organization_id, :uuid
    add_column :users, :organization_id, :uuid
  end
end
