class AddPolymorphicAssociationToFieldValues < ActiveRecord::Migration
  def up
    remove_column :field_values, :calc_structure_id
    add_reference :field_values, :parent, polymorphic: true, index: true
  end

  def down
    add_column :field_values, :calc_structure_id, :integer, null: false
    remove_reference :field_values, :parent, polymorphic: true, index: true
  end
end
