class AddDestroyAttemptOnToStructureImages < ActiveRecord::Migration
  def change
    add_column :structure_images, :destroy_attempt_on, :datetime
  end
end
