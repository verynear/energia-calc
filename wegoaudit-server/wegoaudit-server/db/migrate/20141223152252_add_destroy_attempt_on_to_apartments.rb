class AddDestroyAttemptOnToApartments < ActiveRecord::Migration
  def change
    add_column :apartments, :destroy_attempt_on, :datetime
  end
end
