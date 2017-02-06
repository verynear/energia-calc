module Retrocalc
  class MeasuresController < Retrocalc::ApiController
    before_filter :load_user

    def index
      measures_json = Measure.all.map do |measure|
        { name: measure.name,
          api_name: measure.api_name }
      end

      render json: { measures: measures_json }
    end
  end
end
