class AddYearlyDataToBuildingMonthlyData < ActiveRecord::Migration
  def change
    add_column :building_monthly_data, :yearly_data, :float
  end
end
