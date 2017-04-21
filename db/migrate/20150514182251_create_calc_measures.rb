class CreateCalcMeasures < ActiveRecord::Migration
  def change
    create_table :calc_measures do |t|
      t.string :name, null: false
      t.uuid :wegoaudit_id, null: false

      t.timestamps
    end

    add_index :calc_measures, :wegoaudit_id, unique: true
  end
end
