class MeasureValue < CDQManagedObject
  include CDQRecord

  synchronization_attribute :id

  def measure
    Measure.where(id: measure_id).first
  end

  def boolean_value
    value == 1 ? true : false
  end
end
