class AddCalcOrganizationIds < ActiveRecord::Migration
  def change
    add_column :audit_reports, :calc_organization_id, :integer
    add_column :report_templates, :calc_organization_id, :integer
    add_column :calc_users, :calc_organization_id, :integer
  end
end
