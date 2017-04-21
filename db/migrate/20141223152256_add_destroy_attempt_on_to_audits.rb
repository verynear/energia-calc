class AddDestroyAttemptOnToAudits < ActiveRecord::Migration
  def change
    add_column :audits, :destroy_attempt_on, :datetime
  end
end
