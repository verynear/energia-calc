class AuditReport < ActiveRecord::Base
  delegate :name, to: :audit, prefix: true
  delegate :default_report_template, to: :calc_organization

  validates :name, presence: true
  validates :wegoaudit_id, presence: true

  belongs_to :calc_user
  belongs_to :calc_organization
  belongs_to :report_template

  has_many :apartment_monthly_data
  has_many :building_monthly_data
  has_many :measure_selections
  has_many :calc_measures, through: :measure_selections
  has_many :original_structure_field_values

  has_many :calc_field_values, as: :parent

  def all_structures
    audit.flattened_structures
  end

  def audit
    @audit ||= Wegoaudit::Audit.new(data)
  end

  def belongs_to_user?(other_user)
    user == other_user
  end

  def building_name
    calc_field_values.find_by(field_api_name: 'building_name').value
  end

  def data
    super || {}
  end
end
