class WegoBuilding
  # include WegowiseClient

  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def object_base_path
    'buildings'
  end

  def apartments(building_id)
    raise 'building_id must be specified' unless building_id
    make_wego_call(:get, "#{index_path}/#{building_id}/apartments")
  end

  def meters(building_id)
    raise 'building_id must be specified' unless building_id
    make_wego_call(:get, "#{index_path}/#{building_id}/meters")
  end
end
