class RoofSchemaUpdate < ActiveRecord::Migration
  class StructureType < ActiveRecord::Base; end

  def up
    StructureType.where(name: 'Roof').update_all(name: 'Roof/Attic Space')
  end

  def down
    StructureType.where(name: 'Roof/Attic Space').update_all(name: 'Roof')
  end
end
