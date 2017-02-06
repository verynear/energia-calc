class AuditType < ActiveRecord::Base
  has_many :audits

  validates :name, presence: true
end
