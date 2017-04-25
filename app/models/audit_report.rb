class AuditReport < ActiveRecord::Base

  delegate :default_report_template, to: :calc_organization

  validates :name, presence: true
  validates :wegoaudit_id, presence: true

  belongs_to :user
  belongs_to :calc_organization
  belongs_to :report_template

  has_many :apartment_monthly_data
  has_many :building_monthly_data
  has_many :measure_selections
  has_many :measures, through: :measure_selections
  has_many :original_structure_field_values

  has_many :field_values, as: :parent

  def all_structures
    temp_audit.flattened_structures
  end

  def temp_audit
    @temp_audit ||= TempAudit.new(data)
  end

  def belongs_to_user?(other_user)
    user == other_user
  end

  def building_name
    field_values.find_by(field_api_name: 'building_name').value
  end

  def data
    super || {}
  end
end
