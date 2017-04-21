class CreateContentBlocks < ActiveRecord::Migration
  def change
    create_table :content_blocks do |t|
      t.integer :audit_report_id
      t.string :name
      t.text :markdown

      t.timestamps
    end
  end
end
