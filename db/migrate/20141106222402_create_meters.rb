class CreateMeters < ActiveRecord::Migration
  def change
    create_table :meters, id: :uuid do |t|
      t.integer  :wegowise_id, default: 0, index: true
      t.string   :data_type
      t.string   :coverage
      t.text     :notes
      t.boolean  :for_heating
      t.integer  :n_buildings
      t.string   :scope
      t.string   :other_utility_company
      t.integer  :buildings_count
      t.integer  :utility_company_wegowise_id,              index: true
      t.string   :utility_company_name
      t.boolean  :tenant_pays
      t.string   :status
      t.string   :account_number
      t.string   :importer_version
      t.datetime :attempted_import_at
      t.datetime :status_changed_at
      t.datetime :successful_import_at
      t.datetime :upload_attempt_on
      t.datetime :successful_upload_on

      t.timestamps
    end
  end
end
