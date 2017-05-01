class AddPrimaryToStructureType < ActiveRecord::Migration
  def change
    add_column :audit_strc_types, :primary, :boolean, default: false
  end
end
