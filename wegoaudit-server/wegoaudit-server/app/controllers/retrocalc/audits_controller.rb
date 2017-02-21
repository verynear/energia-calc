module Retrocalc
  class AuditsController < Retrocalc::ApiController
    before_filter :load_user

    def index
      return missing_organization_id unless organization_id
      return unable_to_find_user unless @user

      audits_json = @user.active_audits.map do |audit|
        AuditJsonPresenter.new(audit, top_level_only: true)
      end

      render json: { audits: audits_json }
    end

    def show
      return missing_organization_id unless organization_id
      return unable_to_find_user unless @user

      audit = @user.active_audits.find(params[:id])

      render json: { audit: AuditJsonPresenter.new(audit) }
    rescue ActiveRecord::RecordNotFound
      result = error_response(
        :audit_not_found,
        "Unable to find audit id #{params[:id]}")
      render json: result, status: 404
    end
  end
end
