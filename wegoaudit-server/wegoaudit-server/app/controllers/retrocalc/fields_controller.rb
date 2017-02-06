module Retrocalc
  class FieldsController < Retrocalc::ApiController
    before_filter :load_user

    def index
      fields_json = Field.uniq(:api_name).order(:id).map do |field|
        options = field.field_enumerations.order(:display_order).pluck(:value)
        { name: field.name,
          value_type: field.value_type,
          api_name: field.api_name,
          options: options
        }
      end

      render json: { fields: fields_json }
    end
  end
end
