class WegowiseUserRetrievalWorker
  include Sidekiq::Worker

  def perform(wegowise_user_id)
    user = User.where(wegowise_id: wegowise_user_id).first

    wegowise_user = WegoUser.new(user)
    wegowise_params = wegowise_user.show

    if wegowise_user.success?
      wegowise_params.except!('person_id')
      wegowise_params['wegowise_id'] = wegowise_params.delete('id')

      user.update_attributes(wegowise_params)
    end
  end
end
