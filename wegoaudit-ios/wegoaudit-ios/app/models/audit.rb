class Audit < CDQManagedObject
  include CDQRecord

  synchronization_attribute :id

  scope :sort_archived, sort_by(:is_archived)
  scope :sort_performed_on, sort_by(:performed_on, order: :descending)
  scope :sort_name, sort_by(:name, order: :ascending)
  scope :list_all, sort_archived.sort_performed_on.sort_name

  def user
    @user ||= User.where(id: user_id).first
  end

  def is_locked?
    !locked_by.nil?
  end

  def locked_by_user
    User.where(id: locked_by).first if is_locked?
  end

  def structure
    Structure.where(id: structure_id).first
  end

  def valid?
    audit_type.nil? == false &&
    name.nil? == false && name.length > 0
  end

  def field_values
    FieldValue.where(structure_id: id)
  end

  def audit_type
    AuditType.where(id: audit_type_id).first
  end

  def measure_values
    MeasureValue.where(audit_id: id)
  end

  def get_measure_value(measure)
    measure_values.where(measure_id: measure.id).first
  end

  def set_measure_value(measure_id, value, notes)
    measure = Measure.where(id: measure_id).first
    return if measure.nil?

    if measure_value = get_measure_value(measure)
      measure_value.value = value
      measure_value.notes = notes
    else
      MeasureValue.create_with_uuid(value: value,
                                    notes: notes,
                                    audit_id: self.id,
                                    measure_id: measure.id)
    end
  end
end
