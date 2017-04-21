class CalcUser < ActiveRecord::Base
  VALID_EMAIL_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  has_many :audit_reports
  has_many :measure_selections, through: :audit_reports

  belongs_to :calc_organization

  validates :email,
            format: { with: VALID_EMAIL_REGEXP },
            allow_blank: true

  def available_reports
    calc_organization.audit_reports
  end

  def available_templates
    calc_organization.report_templates
  end

  def calc_organization
    super || NullOrganization.new
  end

end