class Measure < ActiveRecord::Base
  include WegoauditObjectLookup

  validates :name, presence: true
  validates :api_name, uniqueness: true, presence: true

  delegate :structure_types,
           :fields_for_structure_type,
           :grouping_field_api_name,
           :structure_type_definition_for,
           :inputs_only?,
           to: :definition

  def definition
    MeasureDefinition.get(api_name)
  end
  memoize :definition
end
