class AuditStructure < ActiveRecord::Base
  include Cloneable,
          SoftDestruction

  belongs_to :audit_strc_type
  belongs_to :parent_structure, class_name: 'AuditStructure'
  belongs_to :sample_group

  has_many :child_structure_types, through: :audit_strc_type
  has_many :sample_groups, foreign_key: :parent_structure_id
  has_many :structure_images
  
  has_many :substructures, foreign_key: :parent_structure_id,
                           class_name: 'AuditStructure'
  has_many :audit_field_values
  has_many :field_enumerations
  belongs_to :physical_structure, polymorphic: true

  scope :active, -> do
    where(destroy_attempt_on: nil)
  end

  def audit
    @audit ||= Audit.find_by(audit_structure_id: id) if parent_structure_id.nil?
  end

  def parent_audit
    parent_object.is_a?(Audit) ? parent_object : parent_object.parent_audit
  end

  def parent_object
    audit || sample_group || parent_structure
  end

  def short_description
    return physical_structure.short_description if physical_structure
    "#{audit_strc_type.name} - #{name}"
  end

  def value_for_field(audit_field)
      audit_field_values.where(audit_field_id: audit_field.id).first
  end

  def value_for_picker_field(audit_field)
      field_enumerations.where(audit_field_id: audit_field.id)
  end

  # def physical_structure
  #   if physical_structure_type == 'Building'
  #     @physical_structure = Building.find_by(id: physical_structure_id)
  #   elsif physical_structure_type == 'Meter'
  #     @physical_structure ||= Meter.find_by(id: physical_structure_id)
  #   elsif physical_structure_type == 'Apartment'
  #     @physical_structure ||= Apartment.find_by(id: physical_structure_id)
  #   else
  #     @physical_structure = nil
  #   end
  #   @physical_structure
  # end
end
