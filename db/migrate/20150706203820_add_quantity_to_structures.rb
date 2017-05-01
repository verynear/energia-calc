class AddQuantityToStructures < ActiveRecord::Migration
  def change
    change_table :structures do |t|
      t.integer :quantity
    end
  end
end
