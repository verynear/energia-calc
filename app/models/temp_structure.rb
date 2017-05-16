class TempStructure < Generic::Strict
    attr_accessor :audit,
                  :temp_audit,
                  :id,
                  :n_structures,
                  :name,
                  :parent_structure,
                  :photos,
                  :sample_group_id,
                  :substructures,
                  :wegowise_id

    attr_reader :field_values,
                :structure_type

    delegate :api_name, to: :structure_type, prefix: true
    delegate :name, to: :structure_type, prefix: true

    def containing_physical_structure
      return unless parent_structure

      if parent_structure.wegowise_id
        parent_structure
      else
        parent_structure.containing_physical_structure
      end
    end

    def description
      "#{name} - #{location}"
    end

    def description_with_quantity
      if n_structures == 1
        description
      else
        "#{name} - #{location} (#{n_structures.round} total)"
      end
    end

    def field_values=(hash)
      @field_values = HashWithIndifferentAccess.new(hash)
    end

    def genus_structure_type_name
      structure_type.genus_structure_type.name
    end

    def has_field?(api_name)
      field_values.keys.include?(api_name)
    end

    def location
      if wegowise_id
        nil
      elsif sample_group_id
        sample_group[:name]
      elsif containing_physical_structure
        containing_physical_structure.name
      else
        'Top level'
      end
    end

    def sample_group
      return unless sample_group_id

      sample_groups = temp_audit.sample_groups.map do |group|
        HashWithIndifferentAccess.new(group)
      end
      sample_groups.find { |group| group[:id] == sample_group_id }
    end

    def sample_group?
      sample_group.present?
    end

    def structure_type=(hash)
      hash = hash.stringify_keys
      @structure_type = StructureType.by_api_name!(hash['api_name'])
    end
  end