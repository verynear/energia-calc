class AddLayoutToReportTemplates < ActiveRecord::Migration
  def up
    add_column(:report_templates, :layout, :string, null: false)
  end

  def down
    remove_column(:report_templates, :layout)
  end
end
