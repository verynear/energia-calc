module Retrocalc
  class AuditJsonPresenter
    attr_accessor :audit,
                  :top_level_only

    def initialize(audit, top_level_only: false)
      self.audit = audit
      self.top_level_only = top_level_only
    end

    def as_json(options = {})
      top_level = {
        id: audit.id,
        name: audit.name,
        date: audit.performed_on,
        audit_type: audit.audit_type.try(:name)
      }

      return top_level if top_level_only

      top_level[:temp_structures] = structures_json
      top_level[:sample_groups] = sample_groups_json
      top_level[:measures] = measures_json(audit.audit_measure_values)
      top_level[:photos] = photos_json

      top_level
    end

    private

    def measures_json(audit_measure_values)
      audit_measure_values.map do |audit_measure_value|
        { name: audit_measure_value.audit_measure_name,
          api_name: audit_measure_value.audit_measure.api_name,
          notes: audit_measure_value.notes }
      end
    end

    def photos_json
      Retrocalc::PhotosJsonPresenter.new(audit.audit_structure).as_json
    end

    def sample_groups_json
      Retrocalc::SampleGroupsJsonPresenter.new(audit.audit_structure).as_json
    end

    def structures_json
      Retrocalc::StructuresJsonPresenter.new(audit.audit_structure).as_json
    end
  end
end
