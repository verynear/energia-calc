class Audit < ActiveRecord::Base
  # Amount of time to wait before destroying an audit that was marked for
  # deletion. Measured in hours to avoid issues with DST changes.
  GRACE_PERIOD = (24 * 30).hours

  include Cloneable,
          SoftDestruction

  belongs_to :audit_type
  belongs_to :user
  belongs_to :audit_structure
  belongs_to :locked_by_user, foreign_key: :locked_by, class_name: 'User'

  has_many :audit_field_values, through: :audit_structure
  has_many :audit_measure_values

  delegate :audit_strc_type,
           :value_for_field,
           to: :audit_structure

  delegate :name,
           to: :audit_type,
           prefix: true

  scope :to_destroy, -> do
    where('destroy_attempt_on < ?', GRACE_PERIOD.ago)
  end

  def is_locked?
    !locked_by.nil?
  end

  def audit_field_values
    AuditFieldValue.where(audit_structure_id: self.audit_structure_id)
  end

  # def audit_measure_value
  #   AuditMeasureValue.where(audit_id: self.id)
  # end
  
  def audit_measure_value(audit_measure)
    audit_measure_value.find_by(audit_measure_id: audit_measure.id)
  end

  def parent_object
    nil
  end

  def destroy_on_date
    return nil unless destroy_attempt_on.present?
    destroy_attempt_on.since(GRACE_PERIOD).to_date
  end

  def should_be_destroyed?
    return false unless destroy_attempt_on.present?
    destroy_on_date < Date.current
  end
end
