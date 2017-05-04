class SampleGroupCreator < BaseServicer
  attr_accessor :params,
                :parent_structure,
                :audit_strc_type

  attr_reader :sample_group

  def execute!
    create_sample_group
  end

  private

  def create_sample_group
    @sample_group = SampleGroup.create(sample_group_params)
  end

  def current_timestamp
    @current_timestamp ||= DateTime.current
  end

  def sample_group_params
    params.merge(
      parent_structure_id: parent_structure.id,
      
      audit_strc_type_id: audit_strc_type.id,
      successful_upload_on: current_timestamp,
      upload_attempt_on: current_timestamp
    )
  end
end
