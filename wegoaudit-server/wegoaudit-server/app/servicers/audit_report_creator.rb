class AuditReportCreator < Generic::Strict
  attr_accessor :data,
                :report_template,
                :calc_user,
                :wegoaudit_id

  attr_reader :audit_report

  def initialize(*)
    super
    self.report_template ||= user.calc_organization.report_templates
      .first_or_create(layout: 'default', name: 'Base Template')
  end

  def create
    execute
    audit_report
  end

  def execute
    ActiveRecord::Base.transaction do
      create_audit_report
    end
  end

  private

  def associate_measures
    data['measures'].each do |wegoaudit_measure|
      measure = CalcMeasure.by_api_name!(wegoaudit_measure['api_name'])
      MeasureSelectionCreator.new(
        audit_report: audit_report,
        measure: measure,
        notes: wegoaudit_measure['notes']
      ).create
    end
  end

  def create_audit_report
    @audit_report = AuditReport.create!(
      name: data['name'],
      user_id: user.id,
      organization_id: calc_user.calc_organization_id,
      data: data,
      report_template: report_template,
      wegoaudit_id: wegoaudit_id)

    associate_measures
    create_field_values
    import_wegowise_data
  end

  def create_field_values
    CalcField.where(level: 'audit_report').each do |calc_field|
      options = { field_api_name: field.api_name }
      if calc_field.api_name == 'audit_date'
        options[:value] = audit_report.audit.date
      elsif audit_report.audit.field_values[calc_field.api_name] != nil
        options[:value] = audit_report.audit.field_values[calc_field.api_name]
      end

      audit_report.calc_field_values.create!(options)
    end
  end

  def import_wegowise_data
    structures = data['structures']
    wegowise_ids = WegowiseIdFinder.new(structures).find_ids

    start_data_import_workers(wegowise_ids)
  end

  def start_data_import_workers(wegowise_ids)
    building_ids = wegowise_ids['building'][:ids]
    building_ids.each do |id|
      MonthlyDataImportWorker.perform_async(
        user.id, id, 'Building', audit_report.id)
    end

    apartment_ids = wegowise_ids['apartment'][:ids]
    apartment_ids.each do |id|
      MonthlyDataImportWorker.perform_async(
        user.id, id, 'Apartment', audit_report.id)
    end
  end
end
