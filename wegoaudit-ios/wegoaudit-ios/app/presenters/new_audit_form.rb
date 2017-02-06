class NewAuditForm < Formotion::Form
  def initialize(*args)
    super({
      title: 'New Audit',
      row_height: 100,
      sections: [{
        rows: [
          {
            title: 'Name',
            type: :required_string,
            placeholder: 'Name your audit',
            key: :name,
            auto_correction: :no,
            auto_capitalization: :words
          },
          {
            title: 'Type',
            type: :required_picker,
            items: [nil] + audit_types,
            placeholder: 'Select an audit type',
            input_accessory: :done,
            key: :audit_type
          },
          {
            title: 'Date',
            type: :date,
            value: Time.now.to_i,
            format: :medium,
            input_accessory: :done,
            key: :performed_on
          }
        ]
      }]
    })
  end

  private

  def audit_types
    @audit_types ||= AuditType.active
                              .map(&:name)
                              .sort
  end
end
