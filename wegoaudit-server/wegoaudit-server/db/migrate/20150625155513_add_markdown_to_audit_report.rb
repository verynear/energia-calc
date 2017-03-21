class AddMarkdownToAuditReport < ActiveRecord::Migration
  def change
    change_table :audit_reports do |t|
      t.text :markdown
    end
  end
end
