class AddStructureToAudits < ActiveRecord::Migration
  def change
    add_column :audits, :audit_structure_id, :uuid, index: true
  end
end
