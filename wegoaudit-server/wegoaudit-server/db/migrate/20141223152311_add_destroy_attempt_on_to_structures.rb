class AddDestroyAttemptOnToStructures < ActiveRecord::Migration
  def change
    add_column :structures, :destroy_attempt_on, :datetime
  end
end
