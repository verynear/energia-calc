class MeterImportService < BaseServicer
  attr_accessor :meter, :organization, :params, :user

  def execute!
    preprocess_params
    update_or_create_meter
    queue_metering_imports
  end

  private

  def update_or_create_meter
    @meter = Meter.find_by(wegowise_id: params['wegowise_id'], cloned: false)
    return @meter.update_attributes(params) if @meter.present?
    @meter = Meter.create!(params.merge(cloned: false))
  end

  def queue_metering_imports
    MeteringRetrievalWorker.perform_async(meter.wegowise_id, retrieval_user.id)
  end

  def preprocess_params
    @params = WegoHash.new(@params, conversions: conversions).flatten
  end

  def conversions
    { buildings_count: :n_buildings }
  end

  def retrieval_user
    return user if user && current_user
    return organization.owner if organization
    raise 'An organization or user that has allowed access to Wegowise must be
           included in the initialization parameters.'.squish
  end
end
