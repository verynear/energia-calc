module Web
  class MeasuresController < BaseController
    def update
      measure = Measure.find(params[:id])
      measure_value = MeasureValue.find_or_create_by(
        audit_id: current_audit.id,
        measure_id: measure.id
      )

      if measure_value.update(measure_params)
        head 204
      else
        head 422
      end
    end

    def measure_params
      current_timestamp = DateTime.current
      params.permit(:value, :notes)
            .merge(upload_attempt_on: current_timestamp,
                   successful_upload_on: current_timestamp)
    end
  end
end
