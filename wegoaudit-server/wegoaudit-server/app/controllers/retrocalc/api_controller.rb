module Retrocalc
  class ApiController < ApplicationController
    def load_user
      @user = current_user
    end

    def organization_id
      params[:organization_id]
    end

    def missing_organization_id
      result = error_response(
        :missing_organization_id,
        'organization_id is a required parameter')
      render json: result, status: 400
    end

    def unable_to_find_user
      result = error_response(
        :user_not_found,
        'Unable to find organization id #{organization_id}')
      render json: result, status: 404
    end

    def error_response(code, message)
      {
        error: {
          code: code,
          message: message
        }
      }
    end
  end
end

