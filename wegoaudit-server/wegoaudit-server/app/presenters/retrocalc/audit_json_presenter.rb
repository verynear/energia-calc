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

      top_level[:structures] = structures_json
      top_level[:sample_groups] = sample_groups_json
      top_level[:measures] = measures_json(audit.measure_values)
      top_level[:photos] = photos_json

      top_level
    end

    private

    def measures_json(measure_values)
      audit.measure_values.map do |measure_value|
        { name: measure_value.measure_name,
          api_name: measure_value.measure.api_name,
          notes: measure_value.notes }
      end
    end

    def photos_json
      PhotosJsonPresenter.new(audit.structure).as_json
    end

    def sample_groups_json
      SampleGroupsJsonPresenter.new(audit.structure).as_json
    end

    def structures_json
      StructuresJsonPresenter.new(audit.structure).as_json
    end
  end
end
