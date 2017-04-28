class CreateStructureTypes < ActiveRecord::Migration
  def change
    create_table :audit_strc_types, id: :uuid do |t|
      t.uuid :parent_structure_type_id, index: true
      t.string :name
      t.boolean :active
      t.integer :display_order

      t.timestamps
    end
  end
end
