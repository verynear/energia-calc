class AddDestroyAttemptOnToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :destroy_attempt_on, :datetime
  end
end
