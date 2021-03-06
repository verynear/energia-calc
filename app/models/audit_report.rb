class AuditReport < ActiveRecord::Base
  attr_accessor :attachments

  delegate :default_report_template, to: :organization

  validates :name, presence: true
  validates :wegoaudit_id, presence: true

  belongs_to :user
  belongs_to :organization
  belongs_to :report_template

  has_many :apartment_monthly_data
  has_many :building_monthly_data
  has_many :measure_selections
  has_many :measures, through: :measure_selections
  has_many :original_structure_field_values
  has_many :attachments
  accepts_nested_attributes_for :attachments, allow_destroy: true

  has_many :field_values, as: :parent

  def all_structures
    audit.flattened_structures
  end

  def audit
    @audit ||= TempAudit.new(data)
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
