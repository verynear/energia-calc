class SessionsController < ApplicationController
  def new
     if session[:user_id]
       redirect_to root_path
     else
       redirect_to 'users/sign_in'
     end
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
end
