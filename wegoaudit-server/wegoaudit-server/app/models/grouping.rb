class Grouping < ActiveRecord::Base
  belongs_to :structure_type
  has_many :fields
  has_many :field_enumerations, through: :fields

  validates :name, presence: true
  validates :display_order, presence: true,
                            uniqueness: { scope: [:structure_type_id] }
  validates :structure_type, presence: true
end
