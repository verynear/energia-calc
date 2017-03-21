class CreateOriginalStructureFieldValues < ActiveRecord::Migration
  def change
    create_table :original_structure_field_values do |t|
      t.references :audit_report
      t.string :structure_wegoaudit_id
      t.string :value
      t.string :field_api_name
    end

    add_foreign_key :original_structure_field_values,
                    :audit_reports,
                    on_delete: :cascade
    add_index :original_structure_field_values,
              [:structure_wegoaudit_id, :field_api_name, :audit_report_id],
              unique: true,
              name: 'original_structure_field_values_unique_index'
  end
end
