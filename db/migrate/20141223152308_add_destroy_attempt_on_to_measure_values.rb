class AddDestroyAttemptOnToAuditMeasureValues < ActiveRecord::Migration
  def change
    add_column :audit_measure_values, :destroy_attempt_on, :datetime
  end
end
