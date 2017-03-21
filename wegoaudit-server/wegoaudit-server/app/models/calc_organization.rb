class CalcOrganization < ActiveRecord::Base
  has_many :audit_reports
  has_many :report_templates
  has_many :calc_users

  validates :name, presence: true

  def default_report_template
    report_templates.first
  end
end
