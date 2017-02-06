module Retrocalc
  class ApiController < ApplicationController
    def load_user
      @user = User.find_by(wegowise_id: wegowise_id)
    end

    def wegowise_id
      params[:wegowise_id]
    end

    def missing_wegowise_id
      result = error_response(
        :missing_wegowise_id,
        "wegowise_id is a required parameter")
      render json: result, status: 400
    end

    def unable_to_find_user
      result = error_response(
        :user_not_found,
        "Unable to find wegowise id #{wegowise_id}")
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

