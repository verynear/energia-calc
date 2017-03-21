class ApartmentMonthlyDatum < ActiveRecord::Base
  belongs_to :audit_report

  validates :wegowise_id, presence: true
  validates :data_type, presence: true
end
