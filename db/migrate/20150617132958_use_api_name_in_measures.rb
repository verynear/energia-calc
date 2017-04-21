class UseApiNameInMeasures < ActiveRecord::Migration
  def up
    add_column :calc_measures, :api_name, :string

    if CalcMeasure.where(api_name: nil).any?
      client = WegoauditClient.new(wegowise_id: nil)
      api_measures = client.measures_list
      api_measures.each do |api_measure|
        measure = CalcMeasure.find_by_name(api_measure['name'])
        next unless measure
        measure.update!(api_name: api_measure['api_name'])
      end
    end

    remove_column :calc_measures, :wegoaudit_id
    change_column :calc_measures, :api_name, :string, null: false
    add_index :calc_measures, :api_name, unique: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
