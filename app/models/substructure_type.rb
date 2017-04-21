class SubstructureType < ActiveRecord::Base
  belongs_to :structure_type
  belongs_to :parent_structure_type, class_name: 'StructureType'
end
