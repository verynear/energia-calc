class UsersController < ApplicationController
  # before_filter :authenticate_user!
  # before_filter :correct_user?, :except => [:index]

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    # @buildings = WegoBuilding.new(current_user).index
    @buildings = Building.all

    render(json: @user.as_json)
  end

  private

  def get_user_id
    return params[:id] if params[:id].present?
    return session[:user_id]
  end
end
