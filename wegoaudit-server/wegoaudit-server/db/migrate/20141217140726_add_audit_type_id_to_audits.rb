class AddAuditTypeIdToAudits < ActiveRecord::Migration
  def change
    add_column :audits, :audit_type_id, :uuid
    add_foreign_key :audits, :audit_types, column: :audit_type_id
  end
end
