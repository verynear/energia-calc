class Calc::SecuredController < ApplicationController
  before_action(:ensure_user_signed_in)

  def ensure_user_signed_in
    unless user_signed_in?
      flash[:alert] = 'You are not allowed to view this page.'
      redirect_to root_path
    end
  end
end
