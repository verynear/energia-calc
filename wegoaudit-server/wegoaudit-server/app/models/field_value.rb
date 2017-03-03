class FieldValue < ActiveRecord::Base
  include Cloneable,
          SoftDestruction

  belongs_to :field
  belongs_to :structure

  validates :field_id, presence: true, uniqueness: { scope: :structure_id }
  validates :structure_id, presence: true

  def value=(val)
    return if val.nil?
    public_send("#{value_type}=", val)
  end

  def value
    public_send("#{value_type}")
  end

  def field
    @field ||= Field.where(id: field_id).first
  end

  def structure
    @structure ||= Structure.where(id: structure_id)
  end

  def string_value
    @string_value = FieldValue.where(structure_id: structure_id).where.not(string_value: nil)
  end

  private

  def value_type
    field.storage_type
  end

  def convert_value(val)
    field.convert_value(val)
  end
end
