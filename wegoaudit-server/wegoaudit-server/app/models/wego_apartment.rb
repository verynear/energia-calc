class WegoApartment
  # include WegowiseClient

  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def object_base_path
    'apartments'
  end

  def meters(apartment_id)
    raise 'building_id must be specified' unless building_id
    make_wego_call(:get, "#{index_path}/#{apartment_id}/meters")
  end
end
