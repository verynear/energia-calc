class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # before_action :authenticate_user!
  before_action :set_raven_context
  skip_before_action :verify_authenticity_token, if: :json_request?



  protected

  def json_request?
    request.format.json?
  end

  private
    # def current_user
    #   begin
    #     @current_user ||= User.find_by provider: "developer"
    #   rescue Exception => e
    #     nil
    #   end
    # end

    # def user_signed_in?
    #   # return true if current_user
    #   return true
    # end

    # def correct_user?
    #   @user = User.find(params[:id])
    #   # unless current_user == @user
    #   #   redirect_to root_url, :alert => "Access denied."
    #   # end
    # end

    # def authenticate_user!
    #   if !current_user
    #      redirect_to root_url, :alert => 'You need to sign in for access to this page.'
    #   end
    # end

    def set_raven_context
      Raven.user_context(id: session[:current_user_id]) # or anything else in session
      Raven.extra_context(params: params.to_unsafe_h, url: request.url)
    end

    def mobile_device?
      return true if request.user_agent =~ /Mobile|webOS/
      false
    end

end
