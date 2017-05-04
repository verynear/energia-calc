class Grouping < ActiveRecord::Base
  belongs_to :audit_strc_type
  has_many :audit_fields
  has_many :field_enumerations, through: :audit_fields
  has_many :audit_field_values, through: :audit_fields

  validates :name, presence: true
  validates :display_order, presence: true,
                            uniqueness: { scope: [:audit_strc_type_id] }
  validates :audit_strc_type, presence: true
end
