require 'zip'

class AuditUsageDataArchive
  attr_accessor :audit_report,
                :path,
                :zip

  def initialize(audit_report)
    @audit_report = audit_report
    @path = Rails.root.join('tmp', "#{SecureRandom.hex}.zip").to_s
    @zip = Zip::File.open(path, Zip::File::CREATE)
  end

  def basename
    "#{audit_report.name} usage data.zip"
  end

  def build
    entries.each { |name, content| add_entry(name, content) }
    zip.commit
  end

  def delete
    File.unlink(@path)
  end

  def entries
    data = AuditUsageDataPresenter.new(audit_report).data

    data.map do |datum, structure_name|
      [entry_name(datum, structure_name),
       MonthlyDatumCsvFormatter.new(datum, structure_name).to_csv]
    end
  end

  def inspect
    %(#<AuditUsageDataArchive path="#{path}">)
  end

  alias_method :to_str, :to_s

  def to_s
    build unless File.exist?(path)
    File.read(path)
  end
  alias_method :read, :to_s

  private

  def add_entry(name, content)
    zip.get_output_stream(name) { |csv| csv << content }
  end

  def entry_name(datum, structure_name)
    combined_name = "#{structure_name} - #{datum.data_type}"
    "#{combined_name.tr('/', '-')}.csv"
  end
end
