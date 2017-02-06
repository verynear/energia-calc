class CreateMeasures < ActiveRecord::Migration
  def change
    create_table :measures, id: :uuid do |t|
      t.string :name
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
