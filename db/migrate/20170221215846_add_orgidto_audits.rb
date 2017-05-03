class AddOrgidtoAudits < ActiveRecord::Migration
  def change
  	add_column :audits, :organization_id, :uuid
  end
end
