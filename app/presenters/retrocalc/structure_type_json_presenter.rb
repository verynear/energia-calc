module Retrocalc
  class StructureTypeJsonPresenter
    attr_reader :audit_strc_type

    def initialize(audit_strc_type)
      @audit_strc_type = audit_strc_type
    end

    def as_json
      {
        name: audit_strc_type.name,
        api_name: audit_strc_type.api_name,
        genus_api_name: audit_strc_type.genus_structure_type.api_name,
        parent_api_name: audit_strc_type.parent_structure_type.api_name
      }
    end
  end
end
