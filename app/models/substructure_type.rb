class SubstructureType < ActiveRecord::Base
  belongs_to :audit_strc_type
  belongs_to :parent_structure_type, class_name: 'AuditStrcType'
end
