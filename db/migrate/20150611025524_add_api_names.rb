class AddApiNames < ActiveRecord::Migration
  class Structuretype < ActiveRecord::Base
    include ApiNameGeneration
  end
  class AuditMeasure < ActiveRecord::Base
    include ApiNameGeneration
  end
  class Field < ActiveRecord::Base
    include ApiNameGeneration
  end

  def up
    add_column :structure_types, :api_name, :string
    StructureType.all.each(&:generate_api_name!)
    add_column :audit_measures, :api_name, :string
    AuditMeasure.all.each(&:generate_api_name!)
    add_column :fields, :api_name, :string
    Field.all.each(&:generate_api_name!)

    change_column :structure_types, :api_name, :string, null: false
    change_column :audit_measures, :api_name, :string, null: false
    change_column :fields, :api_name, :string, null: false

    add_index :structure_types,
              [:api_name, :parent_structure_type_id],
              unique: true
    add_index :fields, [:api_name, :grouping_id], unique: true
    add_index :audit_measures, :api_name, unique: true
  end

  def down
    remove_column :structure_types, :api_name
    remove_column :audit_measures, :api_name
    remove_column :fields, :api_name
  end
end
