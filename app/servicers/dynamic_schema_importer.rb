class DynamicSchemaImporter < BaseServicer
  def execute!
    open_csv('db/seed_dynamic_schema.csv').each do |row|
      next unless row.valid?

      if row.object_name == audit_structure_type.name
        create_notes_field(audit_structure_type)
        create_details_field(audit_structure_type, row)
      else
        created_types = create_structure_type_hierarchy(row)
        created_types.each do |type|
          create_notes_field(type)
          create_details_field(type, row)
        end
      end
    end
  end

  private

  def audit_structure_type
    @audit_structure_type ||= AuditStrcType.find_or_create_by(
      name: 'Audit',
      active: true,
      display_order: 1,
      primary: true)
  end

  def create_details_field(structure_type, row)
    return unless row.field_valid?

    grouping = audit_strc_type.groupings.find_or_create_by(
      name: row.grouping_name)
    if grouping.display_order.nil?
      grouping.update(display_order: audit_strc_type.groupings.count + 1)
    end

    row.fields.each do |field_options|
      audit_field = grouping.audit_fields.find_or_create_by(name: field_options[:name])

      if audit_field.display_order.nil?
        field_options[:display_order] = grouping.audit_fields.count + 1
      end

      audit_field.update!(field_options)

      row.picker_options.each do |option|
        field_enum = audit_field.field_enumerations.find_or_create_by(value: option)
        if field_enum.display_order.nil?
          field_enum.update(display_order: audit_field.field_enumerations.count + 1)
        end
      end
    end
  end

  def create_notes_field(structure_type)
    row = NotesRow.new(nil)
    create_details_field(structure_type, row)
  end

  def create_structure_type_hierarchy(row)
    created_types = []

    # For each type listed in the parent's column
    parent_objects_for(row.parent_object_names) do |parent_object|
      object_types = object_subtypes = []

      # Create the structure type for this row. It should be a `primary`
      # structure type only if it does not have subtypes.
      object = parent_object.child_structure_types.find_or_create_by(
        name: row.object_name,
        physical_structure_type: row.physical_structure_type)

      if object.display_order.nil?
        display_order = parent_object.child_structure_types.count + 1
        object.update(display_order: display_order)
      end
      object.update(primary: !row.has_child_types?)

      # If the row has child types, create them
      object_types = row.object_types.each do |type|
        object_type = object.child_structure_types.find_or_create_by(
          name: type,
          physical_structure_type: row.physical_structure_type,
          primary: true)
        object_types << object_type
        if object_type.display_order.nil?
          object_type.update(display_order: object_types.length + 1)
        end

        # If the row has child subtypes, create them
        row.object_subtypes.each do |subtype|
          object_subtype = object_type.child_structure_types.find_or_create_by(
            name: subtype,
            physical_structure_type: row.physical_structure_type,
            primary: true)
          object_subtypes << object_subtype
          if object_subtype.display_order.nil?
            object_subtype.update(display_order: object_subtypes.length + 1)
          end
        end
      end

      created_types << [[object], object_types, object_subtypes]
    end

    # Return the lowest structure type child that was created or modified.
    # This will be the structure type that has fields associated with it.
    created_types.map { |types| types.reject(&:blank?).last }.flatten
  end

  def open_csv(path)
    # Only load CSV if we need it.
    require 'csv'

    filepath = Rails.root.join(path)
    csv_text = File.open(filepath, 'r:ISO-8859-1') do |file|
      file.read
    end
    CSV.parse(csv_text, headers: true).map { |row| ObjectRow.new(row) }
  end

  def parent_objects_for(names, &block)
    names.each do |parent_name|
      AuditStrcType.where(name: parent_name).each do |parent_object|
        block.call(parent_object)
      end
    end
  end
end
