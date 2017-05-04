class CreateMeasures < ActiveRecord::Migration
  def change
    create_table :measures do |t|
      t.string :name, null: false
      t.uuid :wegoaudit_id, null: false

      t.timestamps
    end

    add_index :measures, :wegoaudit_id, unique: true
  end
end
