class CreateReportTemplates < ActiveRecord::Migration
  def change
    create_table :report_templates do |t|
      t.string :name
      t.text :markdown

      t.timestamps
    end
  end
end
