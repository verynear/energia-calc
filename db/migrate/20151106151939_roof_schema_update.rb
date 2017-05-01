class RoofSchemaUpdate < ActiveRecord::Migration
  class AuditStrcType < ActiveRecord::Base; end

  def up
    AuditStrcType.where(name: 'Roof').update_all(name: 'Roof/Attic Space')
  end

  def down
    AuditStrcType.where(name: 'Roof/Attic Space').update_all(name: 'Roof')
  end
end
