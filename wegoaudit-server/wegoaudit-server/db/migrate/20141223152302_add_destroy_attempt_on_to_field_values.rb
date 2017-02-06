class AddDestroyAttemptOnToFieldValues < ActiveRecord::Migration
  def change
    add_column :field_values, :destroy_attempt_on, :datetime
  end
end
