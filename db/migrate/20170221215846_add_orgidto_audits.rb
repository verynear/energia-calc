class AddOrgidtoAudits < ActiveRecord::Migration
  def change
  	add_column :audits, :organization_id, :integer
  end
end
