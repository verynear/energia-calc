class Meter < ActiveRecord::Base
  include Cloneable,
          SoftDestruction

  has_many :audit_structures, as: :physical_structure

  def name=(new_name)
    self.account_number = new_name
  end

  def name
    self.account_number
  end

  def short_description
    [data_type, account_number].compact.join(' - ')
  end

  def self.audit_strc_type
    AuditStrcType.find_by(physical_structure_type: 'Meter')
  end
end
