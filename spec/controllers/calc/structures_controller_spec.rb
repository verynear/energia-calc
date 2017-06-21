require 'rails_helper'

describe Calc::StructuresController do
  include Devise::SessionHelpers

  let!(:field) { create(:field) }
  let!(:structure_change) { create(:structure_change) }
  let!(:structure) { create(:structure, structure_change: structure_change) }

  before do
    allow(AuditReportSummarySerializer).to receive(:new)
  end

  it 'does not allow access to a field value that a user does not own' do
    user = create(:user)
    session[:user_id] = user.id

    put :update, id: structure.id

    expect(response.body).to eq('')
    expect(response.status).to eq(403)
  end

  it 'allows access to a field value that a user owns' do
    user = structure_change.measure_selection.audit_report.user

    session[:user_id] = user.id

    put :update, id: structure.id, structure: { name: 'New name' }

    expect(response.status).to eq(200)
  end
end
