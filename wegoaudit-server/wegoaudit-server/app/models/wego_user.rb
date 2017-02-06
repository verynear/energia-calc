class WegoUser
  include WegowiseClient

  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def object_base_path
    'user'
  end
end
