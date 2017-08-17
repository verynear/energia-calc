class Organization < ActiveRecord::Base
  MEMBER = 'member'
  ADMIN = 'admin'
  OWNER = 'owner'
  ROLES = [MEMBER, ADMIN, OWNER]

  has_many :organization_buildings
  has_many :buildings, through: :organization_buildings

  has_many :audit_reports
  has_many :report_templates
  has_many :users

  validates :owner, presence: true
  validates :name, presence: true

  def default_report_template
    report_templates.first
  end
end
