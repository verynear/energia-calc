class CreateAuditMeasures < ActiveRecord::Migration
  def change
    create_table :audit_measures, id: :uuid do |t|
      t.string :name
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
