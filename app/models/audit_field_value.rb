class AuditFieldValue < ActiveRecord::Base
  include Cloneable,
          SoftDestruction

  belongs_to :audit_field
  belongs_to :structure

  validates :audit_field_id, presence: true, uniqueness: { scope: :structure_id }
  validates :structure_id, presence: true

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

  def structure
    @structure ||= Structure.where(id: structure_id)
  end

  # def string_value
  #   @string_value = FieldValue.where(structure_id: structure_id).where.not(string_value: nil)
  # end

  private


  def value_type
    audit_field.storage_type
  end

  def convert_audit_value(val)
    audit_field.convert_audit_value(val)
  end
end
