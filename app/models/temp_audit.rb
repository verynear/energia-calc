class TempAudit < Generic::Strict
    attr_reader :date,
                :structures,
                :temp_structures
                

    attr_accessor :audit_type,
                  :id,
                  :measures,
                  :name,
                  :photos,
                  :sample_groups

    def initialize(*)
      super
      self.temp_structures ||= []
      self.measures ||= []
    end

    def date=(string_or_date)
      @date = string_or_date.to_datetime.strftime('%b %d, %Y  %H:%M')
    end

    def flattened_structures
      temp_structures.each_with_object([]) do |structure, array|
        append_structures_to_array(array, structure)
      end
    end

    def formatted_date
      date.strftime('%m/%d/%Y')
    end

    def temp_structures=(json_structures)
      @temp_structures = build_structures(json_structures)
    end

    private

    def append_structures_to_array(array, structure)
      array << structure
      structure.substructures.each do |substructure|
        append_structures_to_array(array, substructure)
      end
    end

    def build_structures(json_structures, parent_structure = nil)
      json_structures.map do |json_structure|
        substructures_json = json_structure.delete('substructures') || []
        temp_structure = TempStructure.new(
          json_structure.merge(
            parent_structure: parent_structure,
            audit: self))
        temp_structure.substructures =
          build_structures(substructures_json, temp_structure)
        temp_structure
      end
    end
  end