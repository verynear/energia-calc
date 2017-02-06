class MeasureValue < ActiveRecord::Base
  include Cloneable,
          SoftDestruction

  belongs_to :measure
  belongs_to :audit

  validates :audit_id, presence: true
  validates :measure_id, presence: true

  delegate :name, to: :measure, prefix: true
end
