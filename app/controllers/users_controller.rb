class UsersController < ApplicationController
  before_filter :superadmin?, :except => [:index]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @active_audits = Audit.where(user_id: @user.id)
    @buildings = Building.all

    @organization = Organization.find(@user.organization_id)
  end

  def edit
    @user = User.find(params[:id])
    @active_audits = Audit.where(user_id: @user.id)
  end


  def update
    @user = User.find(params[:id])
    clean_params = user_params.reject {|k, v| v == ""}
    if @user.update!(clean_params)
      flash[:success] = 'User account was successfully updated.'
      redirect_to users_path
    else
      flash[:alert] = 'Missing info, unable to update user account'
      @active_audits = Audit.where(user_id: @user.id)
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @organization = Organization.find(@user.organization_id)
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  rescue ActiveRecord::InvalidForeignKey
    flash[:alert] = 'User has active audits, unable to delete'
    render 'show'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :username, :organization_id, :phone, :first_name, :last_name, :role, :password,
                                     :password_confirmation)
  end

  def get_user_id
    return params[:id] if params[:id].present?
    return session[:user_id]
  end
end
