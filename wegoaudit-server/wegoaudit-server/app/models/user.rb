class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :audits
  has_many :memberships
  has_many :organizations, through: :memberships
  has_many :buildings, through: :organizations


  # def self.create_with_omniauth(auth)
  #   # TODO: Move this to a service
  #   user = create! do |user|
  #     user.provider = auth['provider']
  #     user.wegowise_id = auth['uid']
  #     user.token = auth['extra'].access_token.token
  #     user.secret = auth['extra'].access_token.secret
  #     if auth['info']
  #        user.username = auth['info']['username'] || ''
  #     end
  #     wegowise_user = WegoUser.new(user)
  #     wegowise_params = wegowise_user.show
  #     user.assign_attributes(wegowise_params.except(:person_id, :id))
  #     user
  #   end
  #   #  create(
  #   #   provider: 'developer',
  #   #   wegowise_id: '1234',
  #   #   username: 'JoeTest',
  #   #   wegowise_user: WegoUser.new(user),
  #   #   wegowise_params: wegowise_user.show,
  #   #   user.assign_attributes(wegowise_params.except(:person_id, :id))
  #   # user
  # end

  def active_audits
    audits.active
  end

  def full_name(reverse = false)
    name_array = [first_name, last_name]
    return name_array.reverse.compact.join(', ') if reverse
    name_array.compact.join(' ')
  end

  # def has_authenticated?
  #   # token.present? && secret.present?
  #   true
  # end

  def available_audits
    @available_audits ||= if organizations.first.present?
      Audit.where(user: organizations.first.users)
    else
      audits
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
      email: email }
  end
end
