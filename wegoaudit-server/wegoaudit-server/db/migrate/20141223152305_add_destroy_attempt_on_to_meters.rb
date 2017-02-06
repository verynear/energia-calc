class AddDestroyAttemptOnToMeters < ActiveRecord::Migration
  def change
    add_column :meters, :destroy_attempt_on, :datetime
  end
end
