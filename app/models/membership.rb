class Membership < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user

  validates :organization, presence: true
  validates :user, presence: true

  validates :access, inclusion: AccessLevel::SHARED,
                     allow_nil: true

  validates :role, inclusion: Organization::ROLES,
                   allow_nil: false
  validates :user, uniqueness: { scope: :organization }

  delegate :full_name, to: :user
end
