class AddQuantityToCalcStructures < ActiveRecord::Migration
  def change
    change_table :calc_structures do |t|
      t.integer :quantity
    end
  end
end
