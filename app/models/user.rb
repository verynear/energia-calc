class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :rememberable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable
  VALID_EMAIL_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  
  has_many :audits
  has_many :memberships
  has_many :organizations, through: :memberships
  has_many :buildings, through: :organizations

  has_many :audit_reports
  has_many :measure_selections, through: :audit_reports

  belongs_to :organization

  validates :email,
            format: { with: VALID_EMAIL_REGEXP },
            allow_blank: true


  def active_audits
    audits.active
  end

  def full_name(reverse = false)
    name_array = [first_name, last_name]
    return name_array.reverse.compact.join(', ') if reverse
    name_array.compact.join(' ')
  end

  def has_authenticated?
    return false unless user_signed_in?
  end

  def available_audits
    @available_audits ||= if organizations.first.present?
      Audit.where(user: organizations.first.users)
    else
      Audit.where(organization_id: organization_id)
    end
  end

  def as_json
    { id: id,
      username: username,
      wegowise_id: wegowise_id,
      first_name: first_name,
      last_name: last_name,
      created_at: created_at,
      updated_at: updated_at,
      auth_token: token,
      email: email,
      organization_id: organization_id }
  end

  def available_reports
    organization.audit_reports
  end

  def available_templates
    organization.report_templates
  end

  def organization
    super || NullOrganization.new
  end

  def adminrole?
    if self.role == 'admin' || self.role == 'superadmin'
      true
    else
      false
    end
  end
end