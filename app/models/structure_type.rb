class StructureType < ActiveRecord::Base
  SAMPLEABLE_TYPES = [
    'Apartment',
    'Common Area'
  ]

  include ApiNameGeneration

  before_create :generate_api_name

  belongs_to :parent_structure_type, class_name: 'StructureType'
  has_many :child_structure_types, foreign_key: :parent_structure_type_id,
                                   class_name: 'StructureType'
  has_many :structures
  has_many :groupings
  has_many :substructure_types
  has_many :child_substructure_types, class_name: 'SubstructureType', foreign_key: :parent_structure_type_id

  validate :validate_unchanged_api_name

  def grandparent_structure_type
    parent_structure_type.try(:parent_structure_type)
  end

  def genus_structure_type
    # Refers to hierarchies like this:
    #
    # Distribution-system
    # LED -> Lighting
    # Gas -> Individual Furnaces -> Heating/Cooling System
    #
    # The hierarchy can only be two rungs high
    if genus_structure_type?
      self
    elsif parent_structure_type.genus_structure_type?
      parent_structure_type
    elsif grandparent_structure_type && grandparent_structure_type.genus_structure_type?
      grandparent_structure_type
    else
      self
    end
  end

  def genus_structure_type?
    !primary?
  end

  def has_physical_structure?
    !physical_structure_type.nil?
  end

  def physical_structure_class
    physical_structure_type.try(:constantize)
  end

  def sampleable?
    SAMPLEABLE_TYPES.include?(name)
  end
end
