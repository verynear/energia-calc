class CalcUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :rememberable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable
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

  def organization
    super || NullOrganization.new
  end

end
