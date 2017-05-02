class AuditFieldValue < ActiveRecord::Base
  include Cloneable,
          SoftDestruction

  belongs_to :audit_field
  belongs_to :audit_structure

  validates :audit_field_id, presence: true, uniqueness: { scope: :audit_structure_id }
  validates :audit_structure_id, presence: true

  def value=(val)
    return if val.nil?
    public_send("#{value_type}=", val)
  end

  def value
    public_send("#{value_type}")
  end

  def audit_field
    @audit_field ||= AuditField.where(id: audit_field_id).first
  end

  def audit_structure
    @audit_structure ||= AuditStructure.where(id: audit_structure_id)
  end

  # def string_value
  #   @string_value = FieldValue.where(audit_structure_id: audit_structure_id).where.not(string_value: nil)
  # end

  private


  def value_type
    audit_field.storage_type
  end

  def convert_audit_value(val)
    audit_field.convert_audit_value(val)
  end
end
