class MeteringRetrievalWorker
  include Sidekiq::Worker

  def perform(wegowise_meter_id, user_id = nil)
    meter = Meter.find_by(wegowise_id: wegowise_meter_id)
    user = User.find(user_id)
    wego_meter = WegoMeter.new(user)
    wego_meter.structures(wegowise_meter_id).each do |metering_params|
      next if metering_params['type'] == 'Development'

      next unless meter.scope[metering_params['type']]
      MeteringImportService.execute!(params: metering_params,
                                     meter: meter,
                                     user: user)
    end
  end
end
