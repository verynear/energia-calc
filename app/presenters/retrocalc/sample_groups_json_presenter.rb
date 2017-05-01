module Retrocalc
  class SampleGroupsJsonPresenter
    attr_accessor :parent_structure

    delegate :sample_groups,
             :substructures,
             to: :parent_structure

    def initialize(parent_structure)
      self.parent_structure = parent_structure
    end

    def as_json
      flattened_sample_groups.map do |sample_group|
        sample_group_json(sample_group)
      end
    end

    private

    def add_sample_groups(audit_structure, array)
      array.concat(audit_structure.sample_groups)
    end

    def flattened_sample_groups
      substructures.each_with_object(sample_groups) do |audit_structure, groups|
        add_sample_groups(audit_structure, groups)
      end
    end

    def sample_group_json(sample_group)
      {
        id: sample_group.id,
        name: sample_group.name,
        n_structures: sample_group.n_structures,
        parent_structure_id: sample_group.parent_structure.id
      }
    end
  end
end
