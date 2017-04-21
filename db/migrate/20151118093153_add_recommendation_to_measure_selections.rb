class AddRecommendationToMeasureSelections < ActiveRecord::Migration
  def change
    add_column :measure_selections, :recommendation, :string
  end
end
