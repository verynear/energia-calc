require 'rails_helper'

describe Calc::FieldValuesController do
  include Devise::SessionHelpers

  let!(:field) { create(:field) }
  let!(:structure_change) { create(:structure_change) }
  let!(:structure) { create(:structure, structure_change: structure_change) }
  let!(:measure_selection) { structure_change.measure_selection }

  before do
    allow(AuditReportSummarySerializer).to receive(:new)
  end

  context 'for a structure' do
    let!(:field_value) do
      create(:field_value, parent: structure, field_api_name: field.api_name)
    end

    it 'does not allow access to a field value that a user does not own' do
      user = create(:user)
      session[:user_id] = user.id

      put :update, id: field_value.id, structure_id: structure.id

      expect(response.body).to eq('')
      expect(response.status).to eq(403)
    end

    it 'allows access to a field value that a user owns' do
      user = measure_selection.audit_report.user

      session[:user_id] = user.id

      put :update, id: field_value.id, structure_id: structure.id, value: 3

      expect(response.status).to eq(200)
    end
  end

  context 'for a measure_selection' do
    let!(:field_value) do
      create(:field_value,
             parent: measure_selection,
             field_api_name: field.api_name)
    end

    it 'does not allow access to a field value that a user does not own' do
      user = create(:user)
      session[:user_id] = user.id

      put :update, id: field_value.id, measure_selection_id: measure_selection.id

      expect(response.body).to eq('')
      expect(response.status).to eq(403)
    end

    it 'allows access to a field value that a user owns' do
      user = measure_selection.audit_report.user

      session[:user_id] = user.id

      put :update,
          id: field_value.id,
          measure_selection_id: measure_selection.id,
          value: 3

      expect(response.status).to eq(200)
    end
  end
end
