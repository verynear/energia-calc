class DynamicSchemaImporter
  class NotesRow < ObjectRow
    def field_valid?
      true
    end

    def grouping_name
      DEFAULT_GROUPING_NAME
    end

    def fields
      [{ name: 'Notes', value_type: 'text' }]
    end

    def picker_options
      []
    end
  end
end
