class AddIsLockedToAudits < ActiveRecord::Migration
  def up
    add_column :audits, :locked_by, :uuid, default: nil
    add_foreign_key :audits, :users, column: :locked_by
  end

  def down
    remove_column :audits, :locked_by
  end
end
