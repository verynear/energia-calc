class AddDestroyAttemptOnToStructures < ActiveRecord::Migration
  def change
    add_column :audit_structures, :destroy_attempt_on, :datetime
  end
end
