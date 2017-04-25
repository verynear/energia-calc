class AddDestroyAttemptOnToAuditFieldValues < ActiveRecord::Migration
  def change
    add_column :audit_field_values, :destroy_attempt_on, :datetime
  end
end
