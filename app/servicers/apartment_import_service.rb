class ApartmentImportService < BaseServicer
  attr_accessor :apartment, :building, :params

  def execute!
    preprocess_params
    find_building
    update_or_create_apartment
    update_or_create_structure
  end

  private

  def find_building
    @building ||= Building.find_by(wegowise_id: @wegowise_building_id,
                                   cloned: false)
  end

  def update_or_create_apartment
    @apartment = Apartment.find_by(wegowise_id: params[:wegowise_id],
                                   cloned: false)
    return @apartment.update_attributes(params) if @apartment
    @apartment = Apartment.create!(@params.merge(building: @building,
                                                 cloned: false))
  end

  def update_or_create_structure
    if @apartment.audit_structure
      @apartment.audit_structure
                .update_attributes(parent_structure_id: @building.audit_structure.id,
                                   name: @apartment.unit_number)
    else
      audit_structure = AuditStructure.create!(audit_strc_type: Apartment.audit_strc_type,
                                    physical_structure: @apartment,
                                    parent_structure_id: @building.audit_structure.id,
                                    name: @apartment.unit_number)
      apartment.audit_structure = audit_structure
    end
  end

  def preprocess_params
    @wegowise_building_id = params.delete('building_id')
    @params = WegoHash.new(@params.except('quarantine'))
  end
end
