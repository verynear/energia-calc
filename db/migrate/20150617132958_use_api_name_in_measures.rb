class UseApiNameInMeasures < ActiveRecord::Migration
  def up
    add_column :measures, :api_name, :string

    if Measure.where(api_name: nil).any?
      client = AuditDigest.new(wegowise_id: nil)
      api_measures = client.measures_list
      api_measures.each do |api_measure|
        measure = Measure.find_by_name(api_measure['name'])
        next unless measure
        measure.update!(api_name: api_measure['api_name'])
      end
    end

    remove_column :measures, :wegoaudit_id
    change_column :measures, :api_name, :string, null: false
    add_index :measures, :api_name, unique: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
