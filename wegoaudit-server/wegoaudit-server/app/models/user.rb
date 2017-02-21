class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :rememberable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable
  has_many :audits
  has_many :memberships
  has_many :organizations, through: :memberships
  has_many :buildings, through: :organizations

  def active_audits
    Audit.where(organization_id: organization_id)
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
end