class RemoveUnmatchedFieldValues < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute(
      'TRUNCATE fields RESTART IDENTITY'
    )

    require Rails.root.join('db', 'seeds')

    api_names = Field.pluck('api_name')

    field_values = FieldValue.where.not(field_api_name: api_names)
    field_values.destroy_all
  end
end