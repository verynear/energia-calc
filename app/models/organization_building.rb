class OrganizationBuilding < ActiveRecord::Base
  belongs_to :organization
  belongs_to :building

  validates :organization, presence: true
  validates :building, presence: true
  validates :building, uniqueness: { scope: :organization }
end
