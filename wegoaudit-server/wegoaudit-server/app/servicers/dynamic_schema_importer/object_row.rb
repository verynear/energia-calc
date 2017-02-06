class DynamicSchemaImporter
  # Object wrapper for rows in the seed CSV. Should encapsulate all logic
  # surrounding how to interpret the data.
  class ObjectRow

    # Default name to group Field records into.
    DEFAULT_GROUPING_NAME = 'General'

    # There's nothing that is actually bad about using the following field
    # names, but the 'Type' and 'Subtype' rows in the source spreadsheet denote
    # something that should not be imported.
    INVALID_DATA_FIELDS = [
      'Type',
      'Subtype']

    # The following structure types correspond to physical structures in
    # WegoWise, and should have their physical_structure_type set.
    PHYSICAL_STRUCTURE_TYPES = [
      'Apartment',
      'Building',
      'Meter']

    # Only create certain types of fields to avoid creating types that
    # Formotion cannot display.
    VALID_FIELD_TYPES = [
      'currency',
      'date',
      'decimal',
      'email',
      'float',
      'integer',
      'multi-picklist',
      'picker',
      'phone',
      'state',
      'string',
      'switch',
      'text']

    attr_reader :row

    def initialize(row)
      @row = row
    end

    def fields
      if field_type == 'multi-picklist'
        multi_picklist_options.map do |option|
          { name: option, value_type: 'check' }
        end
      else
        [{ name: field_name, value_type: field_type }]
      end
    end
    def field_name
      parse_string_field('Data Field')
    end

    def field_type
      @field_type ||= VALID_FIELD_TYPES.find do |i|
        i == parse_string_field('Field Type').downcase
      end
    end

    def grouping_name
      if field_type == 'multi-picklist'
        field_name
      elsif row['Details Category'].present?
        parse_string_field('Details Category')
      else
        DEFAULT_GROUPING_NAME
      end
    end

    def field_valid?
      field_name.present? && field_type.present?
    end

    def has_child_types?
      object_types.present?
    end

    def multi_picklist_options
      return [] if field_type != 'multi-picklist'
      valid_field_options
    end

    def object_name
      parse_string_field('Object (Heating System, Envelop, Water, etc)')
    end

    def object_subtypes
      parse_csv_field('Subtype')
    end

    def object_types
      parse_csv_field('Type')
    end

    def parent_object_names
      parse_csv_field('Parent Object')
    end

    def physical_structure_type
      object_name if PHYSICAL_STRUCTURE_TYPES.include?(object_name)
    end

    def picker_options
      return [] if field_type != 'picker'
      valid_field_options
    end

    def valid_field_options
      parse_csv_field('Validation Rules')
    end

    def valid?
      object_name.present? && !INVALID_DATA_FIELDS.include?(field_name)
    end

    private

    def parse_csv_field(field)
      row[field].to_s.split(',').map(&:strip)
    end

    def parse_string_field(field)
      row[field].to_s.strip
    end
  end
end
