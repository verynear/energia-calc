class Apartment < ActiveRecord::Base
  include Cloneable,
          SoftDestruction

  belongs_to :building
  has_one :audit_structure, as: :physical_structure

  validates :unit_number, presence: true
  validate :only_one_non_cloned

  def self.create_temporary!(wego_id, name)
    create!(wegowise_id: wego_id,
            unit_number: name,
            cloned: false)
  end

  def self.audit_strc_type
    AuditStrcType.find_by(physical_structure_type: 'Apartment')
  end

  def name=(new_name)
    self.unit_number = new_name
  end

  def name
    unit_number
  end

  def short_description
    unit_number
  end

  private

  def only_one_non_cloned
    return if cloned == true || Apartment.where(wegowise_id: wegowise_id,
                                                 cloned: false)
                                         .count == 0
    errors.add(:base, "There can be only one non-cloned Apartment with
                      Wegowise Id #{wegowise_id}".squish)
  end
end
