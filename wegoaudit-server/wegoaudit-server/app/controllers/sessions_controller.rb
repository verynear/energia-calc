class SessionsController < ApplicationController
  def new
    if session[:user_id]
      redirect_to root_path
    else
      redirect_to '/auth/wegowise'
    end
  end

  def create
    auth = request.env['omniauth.auth']
    if user = User.find_by(wegowise_id: auth['uid'].to_s)
      user.provider = auth['provider']
      user.wegowise_id = auth['uid']
      user.token = auth['extra'].access_token.token
      user.secret = auth['extra'].access_token.secret
      user.save
    else
      user = User.create_with_omniauth(auth)
    end

    reset_session
    session[:user_id] = user.id

    if mobile_device?
      redirect_to user_path(user)
    else
      redirect_to root_url, :notice => 'Signed in!'
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
