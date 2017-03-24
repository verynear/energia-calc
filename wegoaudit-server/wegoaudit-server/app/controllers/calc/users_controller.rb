class Calc::UsersController < SecuredController
  def edit
    @page_title = 'My account'
  end

  def update
    if @current_user.update(user_params)
      flash[:alert] = 'Your account was successfully updated.'
    else
      flash[:alert] = 'Sorry, there was an error. Did you enter a valid email?'
    end
    redirect_to action: :edit
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:name, :email, :phone)
  end
end
