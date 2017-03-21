class AddPolymorphicAssociationToCalcFieldValues < ActiveRecord::Migration
  def up
    remove_column :calc_field_values, :calc_structure_id
    add_reference :calc_field_values, :parent, polymorphic: true, index: true
  end

  def down
    add_column :calc_field_values, :calc_structure_id, :integer, null: false
    remove_reference :calc_field_values, :parent, polymorphic: true, index: true
  end
end
