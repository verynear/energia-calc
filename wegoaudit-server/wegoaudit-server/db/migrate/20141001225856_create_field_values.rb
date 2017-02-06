class CreateFieldValues < ActiveRecord::Migration
  def change
    create_table :field_values, id: :uuid do |t|
      t.uuid :field_id, index: true
      t.uuid :structure_id, index: true
      t.string :string_value
      t.float :float_value
      t.decimal :decimal_value
      t.integer :integer_value
      t.datetime :date_value
      t.boolean :boolean_value
      t.datetime :successful_upload_on
      t.datetime :upload_attempt_on

      t.timestamps
    end
  end
end
