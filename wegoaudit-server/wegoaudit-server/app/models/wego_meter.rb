class WegoMeter
  # include WegowiseClient

  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def structures(meter_id)
    raise 'meter_id must be specified' unless meter_id
    make_wego_call(:get, "/api/v1/wego_pro/meters/#{meter_id}/structures")
  end

  def index_path
    "/api/v1/wego_pro/users/#{user.username}/meters"
  end

  def object_base_path
    'meters'
  end
end
