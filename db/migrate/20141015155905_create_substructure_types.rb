class CreateSubstructureTypes < ActiveRecord::Migration
  def change
    create_table :substructure_types, id: :uuid do |t|
      t.uuid :parent_structure_type_id, index: true
      t.uuid :audit_strc_type_id, index: true
      t.integer :display_order

      t.timestamps
    end
  end
end
