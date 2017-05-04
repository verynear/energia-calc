class AuditMeasureValue < ActiveRecord::Base
  include Cloneable,
          SoftDestruction

  belongs_to :audit_measure
  belongs_to :audit

  validates :audit_id, presence: true
  validates :audit_measure_id, presence: true

  delegate :name, to: :audit_measure, prefix: true
end
