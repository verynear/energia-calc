class ApartmentRetrievalWorker
  include Sidekiq::Worker

  def perform(wegowise_apartment_id, user_id)
    user = User.find(user_id)
    wego_apartment = WegoApartment.new(user)
    params = wego_apartment.show(wegowise_apartment_id)
    ApartmentImportService.execute!(params: params)
  end
end
