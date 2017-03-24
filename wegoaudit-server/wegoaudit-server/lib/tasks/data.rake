namespace :data do
  desc 'Check all audit reports for audit json validity'
  task validate_audit_json: :environment do
    AuditReport.all.each do |audit_report|
      begin
        WegoauditSchemaValidator.new.validate!('retrocalc/audit',
                                               'audit' => audit_report.data)
      rescue JSON::Schema::ValidationError => e
        puts "AuditReport ##{audit_report.id} has schema error \"#{e}\""
      end
    end
  end

  desc 'Resync audit reports with invalid audit json (last resort!)'
  task resync_bad_audit_json: :environment do
    AuditReport.all.each do |audit_report|
      begin
        WegoauditSchemaValidator.new.validate!('retrocalc/audit',
                                               'audit' => audit_report.data)
      rescue JSON::Schema::ValidationError => _e
        client = WegoauditClient.new(wegowise_id: audit_report.user.wegowise_id)
        begin
          data = client.audit(audit_report.data['id'])
        rescue WegoauditClient::ApiError
          next
        end
        audit_report.update!(data: data)
      end
    end
  end

  desc 'Destroy unused fields and associated field values'
  task prune_fields: :environment do
    ActiveRecord::Base.connection.execute(
      'TRUNCATE fields RESTART IDENTITY'
    )

    require Rails.root.join('db', 'seeds')

    api_names = CalcField.pluck('api_name')

    calc_field_values = CalcFieldValue.where.not(field_api_name: api_names)
    calc_field_values.destroy_all
  end
end
