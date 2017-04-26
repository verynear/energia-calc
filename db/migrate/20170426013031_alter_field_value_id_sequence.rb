class AlterFieldValueIdSequence < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER SEQUENCE field_values_id_seq START 4763;
    SQL
  end

  def down
    execute <<-SQL
      ALTER SEQUENCE field_values_id_seq;
    SQL
  end
end
