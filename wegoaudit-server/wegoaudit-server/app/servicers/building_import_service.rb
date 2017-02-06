class BuildingImportService < BaseServicer
  attr_accessor :building,
                :organization,
                :params

  def execute!
    preprocess_parameters
    create_or_update_building
    create_structure
    create_organization_building
  end

  private

  def create_or_update_building
    @building = Building.find_by(wegowise_id: params[:wegowise_id],
                                 cloned: false)
    return @building.update_attributes(params) if @building
    @building = Building.create!(params.merge(cloned: false))
  end

  def create_structure
    Structure.where(structure_type_id: Building.structure_type.id,
                    physical_structure_id: @building.id,
                    physical_structure_type: 'Building',
                    name: @building.name)
             .first_or_create

  end

  def create_organization_building
    OrganizationBuilding.where(organization_id: organization.id,
                               building_id: building.id)
                        .first_or_create
  end

  def conversions
    { 'state' => 'state_code' }
  end

  def preprocess_parameters
    @params.delete('basement') if params['basement'].nil?
    @params = WegoHash.new(@params, conversions: conversions)
                      .flatten(without_prefix: :location)
                      .merge(draft: false)
                      .with_indifferent_access
  end
end
