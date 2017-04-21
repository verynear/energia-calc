class SampleGroup < ActiveRecord::Base
  include Cloneable,
          SoftDestruction

  belongs_to :structure_type
  belongs_to :parent_structure, class_name: 'Structure'
  has_many :substructures, foreign_key: :sample_group_id,
                           class_name: 'Structure'

  validates :n_structures, numericality: { only_integer: true }
  validates :name, presence: true
  validates :parent_structure_id, presence: true
  validates :structure_type_id, presence: true

  scope :active, -> { where(destroy_attempt_on: nil) }

  alias_method :parent_object, :parent_structure

  delegate :parent_audit, to: :parent_structure

  def audit
    nil
  end

  def is_complete?
    substructures.length == n_structures
  end

  def sample_groups
    []
  end

  def short_description
    "#{structure_type.name} - #{name} (#{substructures.count} of #{n_structures})"
  end
end
