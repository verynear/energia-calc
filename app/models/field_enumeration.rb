class FieldEnumeration < ActiveRecord::Base
  belongs_to :field

  validates :field_id, presence: true
  validates :value, presence: true
  validates :display_order, presence: true, uniqueness: { scope: :field_id }

end
