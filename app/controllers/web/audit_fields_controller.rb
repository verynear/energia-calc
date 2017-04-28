module Web
  class AuditFieldsController < BaseController
    def update
      audit_field = AuditField.find(params[:id])
      value = params[audit_field.name.parameterize]

      if value.blank?
        # delete field value
      else
        audit_field_value = audit_field.audit_field_values
                           .find_or_initialize_by(audit_structure_id: params[:audit_structure_id])
        audit_field_value.value = value
        audit_field_value.save!
      end
      head 204
    rescue ActiveRecord::RecordInvalid
      head 422
    end
  end
end
