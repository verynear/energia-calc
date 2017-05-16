class TempAudit < Generic::Strict
    attr_reader :date,
                :structures
                

    attr_accessor :audit_type,
                  :id,
                  :measures,
                  :name,
                  :photos,
                  :sample_groups

    def initialize(*)
      super
      self.structures ||= []
      self.measures ||= []
    end

    def date=(string_or_date)
      @date = string_or_date.to_datetime
    end

    def flattened_structures
      structures.each_with_object([]) do |structure, array|
        append_structures_to_array(array, structure)
      end
    end

    def formatted_date
      date.strftime('%m/%d/%Y')
    end

    def structures=(json_structures)
      @structures = build_structures(json_structures)
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
        structure = TempStructure.new(
          json_structure.merge(
            parent_structure: parent_structure,
            audit: self))
        structure.substructures =
          build_structures(substructures_json, structure)
        structure
      end
    end
  end