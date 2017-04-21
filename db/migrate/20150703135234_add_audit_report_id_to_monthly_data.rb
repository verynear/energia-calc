class AddAuditReportIdToMonthlyData < ActiveRecord::Migration
  class ApartmentMonthlyDatum < ActiveRecord::Base; end
  class BuildingMonthlyDatum < ActiveRecord::Base; end

  def change
    ApartmentMonthlyDatum.delete_all
    BuildingMonthlyDatum.delete_all

    add_column :apartment_monthly_data, :audit_report_id, :integer, null: false
    add_column :building_monthly_data, :audit_report_id, :integer, null: false

    add_foreign_key :apartment_monthly_data, :audit_reports, on_delete: :cascade
    add_foreign_key :building_monthly_data, :audit_reports, on_delete: :cascade
  end
end
