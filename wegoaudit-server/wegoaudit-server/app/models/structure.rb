class Structure < ActiveRecord::Base
  include Cloneable,
          SoftDestruction

  belongs_to :structure_type
  belongs_to :parent_structure, class_name: 'Structure'
  belongs_to :sample_group

  has_many :child_structure_types, through: :structure_type
  has_many :sample_groups, foreign_key: :parent_structure_id
  has_many :structure_images
  has_many :substructures, foreign_key: :parent_structure_id,
                           class_name: 'Structure'
  has_many :field_values
  has_many :field_enumerations
  belongs_to :physical_structure, polymorphic: true

  scope :active, -> do
    where(destroy_attempt_on: nil)
  end

  def audit
    @audit ||= Audit.find_by(structure_id: id) if parent_structure_id.nil?
  end

  def parent_audit
    parent_object.is_a?(Audit) ? parent_object : parent_object.parent_audit
  end

  def parent_object
    audit || sample_group || parent_structure
  end

  def short_description
    return physical_structure.short_description if physical_structure
    "#{structure_type.name} - #{name}"
  end

  def value_for_field(field)
      field_values.where(structure_id: structure.id).where(field_id: field.id)
  end

  def value_for_picker_field(field)
      field_enumerations.where(field_id: field.id)
  end
end
