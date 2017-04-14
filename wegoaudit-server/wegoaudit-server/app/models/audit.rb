class Audit < ActiveRecord::Base
  # Amount of time to wait before destroying an audit that was marked for
  # deletion. Measured in hours to avoid issues with DST changes.
  GRACE_PERIOD = (24 * 30).hours

  include Cloneable,
          SoftDestruction

  belongs_to :audit_type
  belongs_to :user
  belongs_to :structure
  belongs_to :locked_by_user, foreign_key: :locked_by, class_name: 'User'

  has_many :field_values, through: :structure
  has_many :measure_values

  delegate :structure_type,
           :value_for_field,
           to: :structure

  delegate :name,
           to: :audit_type,
           prefix: true

  scope :to_destroy, -> do
    where('destroy_attempt_on < ?', GRACE_PERIOD.ago)
  end

  def is_locked?
    !locked_by.nil?
  end

  def field_values
    FieldValue.where(structure_id: self.structure_id)
  end

  def measure_value
    MeasureValue.where(audit_id: self.id)
  end

  def measure_value(measure)
    measure_value.find_by(measure_id: measure.id)
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
