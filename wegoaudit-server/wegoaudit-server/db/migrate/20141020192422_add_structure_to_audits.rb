class AddStructureToAudits < ActiveRecord::Migration
  def change
    add_column :audits, :structure_id, :uuid, index: true
  end
end
