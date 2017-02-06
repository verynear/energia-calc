class Organization < ActiveRecord::Base
  MEMBER = 'member'
  ADMIN = 'admin'
  OWNER = 'owner'
  ROLES = [MEMBER, ADMIN, OWNER]

  belongs_to :owner, class_name: 'User'
  has_many :memberships
  has_many :users, through: :memberships
  has_many :organization_buildings
  has_many :buildings, through: :organization_buildings

  validates :owner, presence: true
  validates :name, presence: true
end
