module Web
  class FieldsController < BaseController
    def update
      field = Field.find(params[:id])
      value = params[field.name.parameterize]

      if value.blank?
        # delete field value
      else
        field_value = field.field_values
                           .find_or_initialize_by(structure_id: params[:structure_id])
        field_value.value = value
        field_value.save!
      end
      head 204
    rescue ActiveRecord::RecordInvalid
      head 422
    end
  end
end
