module Web
  class AuditMeasuresController < BaseController
    def update
      audit_measure = AuditMeasure.find(params[:id])
      audit_measure_value = AuditMeasureValue.find_or_create_by(
        audit_id: current_audit.id,
        audit_measure_id: audit_measure.id
      )

      if audit_measure_value.update(audit_measure_params)
        head 204
      else
        head 422
      end
    end

    def audit_measure_params
      current_timestamp = DateTime.current
      params.permit(:value, :notes)
            .merge(upload_attempt_on: current_timestamp,
                   successful_upload_on: current_timestamp)
    end
  end
end
