module UsersHelper
  def wegowise_account_url
    "#{wegowise_url}/users/#{current_user.username}/edit"
  end

  def wegowise_url
    Rails.application.secrets.wegowise_url
  end
end
