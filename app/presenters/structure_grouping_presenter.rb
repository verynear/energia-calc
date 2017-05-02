class StructureGroupingPresenter
  attr_reader :grouping,
              :audit_structure,
              :audit_field,
              :audit_field_value

  delegate :name,
           to: :grouping

  def initialize(audit_structure, grouping)
    @audit_structure = audit_structure
    @grouping = grouping
  end

  def audit_fields
      grouping.audit_fields.order(:display_order).map do |audit_field|
        if audit_field.value_type != 'picker'
           StructureFieldPresenter.new(audit_structure, audit_field, audit_field_values[audit_field.id])
        else
          if !audit_field_values[audit_field.id]
            StructureFieldPresenter.new(audit_structure, audit_field, collection)
          else
            StructureFieldPresenter.new(audit_structure, audit_field, collection, audit_field_values[audit_field.id]['string_value'])
          end
        end
      end
  end  

  private

    
    def audit_field_values
      @audit_field_values ||= audit_structure.audit_field_values.map do |audit_field_value|
        [audit_field_value.audit_field_id, audit_field_value]
      end.to_h
    end

    def collection
      collection = []
      grouping.field_enumerations.map do |field_enumeration|
        collection << [field_enumeration.value]
      end
      collection
    end

end
