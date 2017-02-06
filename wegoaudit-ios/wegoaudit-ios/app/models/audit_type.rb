class AuditType < CDQManagedObject
  include CDQRecord

  synchronization_attribute :id

  scope :active, where(active: true)
end
