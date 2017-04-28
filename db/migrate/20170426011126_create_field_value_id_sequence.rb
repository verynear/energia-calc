class CreateFieldValueIdSequence < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE SEQUENCE field_values_id_seq;
    SQL
  end

  def down
    execute <<-SQL
      DROP SEQUENCE field_values_id_seq;
    SQL
  end
end

