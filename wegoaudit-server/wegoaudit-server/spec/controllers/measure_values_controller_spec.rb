require 'rails_helper'

describe MeasureValuesController do
  let(:user) { create(:user) }
  let(:audit) { create(:audit, user: user) }
  let(:measure) { create(:measure) }

  before { session[:user_id] = user.id }

  describe 'GET index' do
    it 'returns json with all measure values' do
      create(:measure_value,
             audit_id: audit.id,
             measure_id: measure.id)
      get :index
      expect(response.body).to eq MeasureValue.all.to_json
    end
  end

  describe 'POST create' do
    it 'creates a MeasureValue' do
      measure_value_params = attributes_for(:measure_value,
                                            audit_id: audit.id,
                                            measure_id: measure.id)

      # We need all of the attributes that WegoAudit-iOS will be submitting,
      # but without saving them in the test database.
      measure_value_params.merge!(id: SecureRandom.uuid,
                                  upload_attempt_on: Time.zone.now,
                                  created_at: Time.zone.now,
                                  updated_at: Time.zone.now)
      post :create, measure_value: measure_value_params

      measure_value = MeasureValue.find(measure_value_params[:id])
      expect(measure_value).to be_present
    end
  end

  describe 'POST update' do
    it 'updates an existing MeasureValue' do
      measure_value = create(:measure_value,
                             audit_id: audit.id,
                             measure_id: measure.id)

      measure_value_params = measure_value.attributes
      measure_value_params[:notes] = 'I am a new note'
      post :update, id: measure_value.id, measure_value: measure_value_params

      measure_value.reload
      expect(measure_value.notes).to eq 'I am a new note'
    end
  end

  describe 'GET show' do
    it 'returns json for a single measure value' do
      measure_value = create(:measure_value,
                             audit_id: audit.id,
                             measure_id: measure.id)
      get :show, id: measure_value.id
      expect(response.body).to eq measure_value.to_json
    end
  end
end
