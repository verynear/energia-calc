# This class takes an audit report and provides sub-arrays of MonthlyDatum
# objects and structure names.
#
class AuditUsageDataPresenter < WegoBase
  attr_accessor :audit_report

  def initialize(audit_report)
    @audit_report = audit_report
  end

  def data
    all_data = []

    structure_data('apartment').each do |wegowise_id, structure_name|
      find_data(wegowise_id, 'apartment').all.each do |datum|
        all_data << [datum, structure_name]
      end
    end

    structure_data('building').each do |wegowise_id, structure_name|
      find_data(wegowise_id, 'building').all.each do |datum|
        all_data << [datum, structure_name]
      end
    end

    all_data
  end

  private

  def find_data(wegowise_id, structure_type)
    klass = "#{structure_type.capitalize}MonthlyDatum".constantize
    klass.where(wegowise_id: wegowise_id)
  end

  def monthly_data
    structures = audit_report.data['structures']
    WegowiseIdFinder.new(structures).find_ids_and_names
  end
  memoize :monthly_data

  def structure_data(structure_type)
    ids = monthly_data[structure_type][:ids]
    names = monthly_data[structure_type][:names]
    ids.zip(names)
  end
end
