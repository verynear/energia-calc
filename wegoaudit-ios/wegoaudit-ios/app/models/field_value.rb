class FieldValue < CDQManagedObject
  include CDQRecord

  synchronization_attribute :id

  scope :not_destroyed, where(destroy_attempt_on: nil)
  scope :destroyed, where('destroy_attempt_on != nil')

  def value=(val)
    return if val.nil?
    send("#{value_type}=", convert_value(val))
  end

  def value
    val = send("#{value_type}")
    return val unless field.date?
    val.to_i
  end

  def field
    @field ||= Field.where(id: field_id).first
  end

  def structure
    @structure ||= Structure.where(id: structure_id).first
  end

  private

  def value_type
    field.storage_type
  end

  def convert_value(val)
    field.convert_value(val)
  end
end
