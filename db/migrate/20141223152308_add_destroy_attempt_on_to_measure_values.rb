class AddDestroyAttemptOnToMeasureValues < ActiveRecord::Migration
  def change
    add_column :measure_values, :destroy_attempt_on, :datetime
  end
end
