class RenameTestLayoutToDefault < ActiveRecord::Migration
  def change
    ReportTemplate.where(layout: 'test').update_all(layout: 'default')
  end
end
