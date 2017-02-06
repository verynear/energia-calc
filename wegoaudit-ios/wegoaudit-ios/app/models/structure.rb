class Structure < CDQManagedObject
  include CDQRecord

  synchronization_attribute :id

  scope :not_destroyed, where(destroy_attempt_on: nil)

  def structure_type
    return nil unless structure_type_id
    StructureType.where(id: structure_type_id).first
  end

  def parent_sample_group
    return nil unless sample_group_id
    SampleGroup.where(id: sample_group_id).first
  end

  def parent_structure
    return nil unless parent_structure_id
    Structure.where(id: parent_structure_id).first
  end

  def substructures
    Structure.where(parent_structure_id: id)
  end

  def sample_groups
    SampleGroup.where(parent_structure_id: id)
  end

  def physical_structure=(ph_structure)
    if ph_structure.nil?
      self.physical_structure_type = nil
      self.physical_structure_id = nil
    else
      self.physical_structure_type = physical_structure_type || ph_structure.klazz
      self.physical_structure_id  = ph_structure.id
    end
  end

  def physical_structure
    return nil unless physical_structure_id
    @physical_structure ||= Module.const_get(physical_structure_type).where(id: physical_structure_id).first
  end


  def short_description
    return physical_structure.short_description if physical_structure
    [structure_type.name, name].join(' - ')
  end

  def groupings
    structure_type.groupings
  end

  def generated_form
    f = { sections: [] }
    groupings.each do |grouping|
      f[:sections] << { title: grouping.name, rows: [] }
      grouping.fields.sort_by(:display_order).each do |field|
        field_form = field.form
        value = get_field_value(field)
        field_form.merge!(value: value) if value
        f[:sections].last[:rows] << field_form
      end
    end
    f
  end

  def undestroyed_field_values
    field_values.not_destroyed
  end

  def field_values
    FieldValue.where(structure_id: id)
  end

  def destroyed_field_values
    field_values.destroyed
  end

  def can_have_substructures?
    structure_type.can_have_substructures?
  end

  def find_field_value(key)
    key = key.to_s
    FieldValue.where(field_id: key, structure_id: self.id).first
  end

  def create_field_value(key)
    key = key.to_s
    FieldValue.create_with_uuid(structure_id: self.id, field_id: key)
  end

  def delete_field_value(field_value)
    key = key.to_s
    field_value.destroy
  end

  def presenter
    if physical_structure_type
      presenter_class = "#{physical_structure_type}DetailPresenter"
    else
      presenter_class = 'StructureDetailPresenter'
    end
    Module.const_get(presenter_class).new(self)
  end

  def structure_images
    StructureImage.where(structure_id: id)
  end

  def static_attribute?(key)
    physical_structure && physical_structure.respond_to?("#{key}=")
  end

  def set_static_attribute(key, value)
    physical_structure.send("#{key}=", convert_value(key, value))
  end

  def convert_value(key, value)
    attribute = physical_structure.entity.attributesByName[key.to_s]
    return value unless attribute
    case attribute.attributeType
    when NSInteger32AttributeType then value.to_i
    when NSDecimalAttributeType then BigDecimal.new(value)
    when NSFloatAttributeType then value.to_f
    when NSDateAttributeType then NSDate.dateWithTimeIntervalSince1970(value)
    else
      value
    end
  end

  def get_field_value(field)
    field_value = undestroyed_field_values.where(field_id: field.id).first

    return field_value.value unless field_value.nil?
    return nil
  end

  def set_field_value(key, value)
    key = key.to_s
    if static_attribute?(key)
      set_static_attribute(key, value)
    elsif respond_to?("#{key}=")
      self.public_send("#{key}=", value)
    else
      field_value = find_field_value(key)

      nil_value = nil_or_empty?(value)

      if field_value.nil?
        return if nil_value
        field_value = create_field_value(key)
      elsif nil_value
        return delete_field_value(field_value)
      end

      field_value.value = value
    end
  end
end
