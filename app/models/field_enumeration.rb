class FieldEnumeration < ActiveRecord::Base
  belongs_to :audit_field

  validates :audit_field_id, presence: true
  validates :value, presence: true
  validates :display_order, presence: true, uniqueness: { scope: :audit_field_id }

end
