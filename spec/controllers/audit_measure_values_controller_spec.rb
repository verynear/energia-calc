require 'rails_helper'

describe AuditMeasureValuesController do
  let(:user) { create(:user) }
  let(:audit) { create(:audit, user: user) }
  let(:audit_measure) { create(:audit_measure) }

  before { session[:user_id] = user.id }

  describe 'GET index' do
    it 'returns json with all measure values' do
      create(:audit_measure_value,
             audit_id: audit.id,
             audit_measure_id: measure.id)
      get :index
      expect(response.body).to eq AuditMeasureValue.all.to_json
    end
  end

  describe 'POST create' do
    it 'creates a AuditMeasureValue' do
      audit_measure_value_params = attributes_for(:audit_measure_value,
                                            audit_id: audit.id,
                                            audit_measure_id: audit_measure.id)

      # We need all of the attributes that WegoAudit-iOS will be submitting,
      # but without saving them in the test database.
      audit_measure_value_params.merge!(id: SecureRandom.uuid,
                                  upload_attempt_on: Time.zone.now,
                                  created_at: Time.zone.now,
                                  updated_at: Time.zone.now)
      post :create, audit_measure_value: audit_measure_value_params

      audit_measure_value = AuditMeasureValue.find(audit_measure_value_params[:id])
      expect(audit_measure_value).to be_present
    end
  end

  describe 'POST update' do
    it 'updates an existing AuditMeasureValue' do
      audit_measure_value = create(:audit_measure_value,
                             audit_id: audit.id,
                             audit_measure_id: measure.id)

      audit_measure_value_params = audit_measure_value.attributes
      audit_measure_value_params[:notes] = 'I am a new note'
      post :update, id: audit_measure_value.id, audit_measure_value: audit_measure_value_params

      audit_measure_value.reload
      expect(audit_measure_value.notes).to eq 'I am a new note'
    end
  end

  describe 'GET show' do
    it 'returns json for a single measure value' do
      audit_measure_value = create(:audit_measure_value,
                             audit_id: audit.id,
                             audit_measure_id: measure.id)
      get :show, id: audit_measure_value.id
      expect(response.body).to eq audit_measure_value.to_json
    end
  end
end
