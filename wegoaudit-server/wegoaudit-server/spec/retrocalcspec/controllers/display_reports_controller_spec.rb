require 'rails_helper'

describe DisplayReportsController do
  include Omniauth::SessionHelpers

  let!(:org1) { create(:organization) }
  let!(:user1) { create(:user, organization: org1) }
  let!(:audit_report) { create(:audit_report, user: user1) }

  let!(:org2) { create(:organization) }
  let!(:user2) { create(:user, organization: org2) }

  describe '#edit' do
    it 'does not allow access to an audit report that a user does not own' do
      session[:user_id] = user2.id

      put :edit, audit_report_id: audit_report.id

      expect(response.body).to eq('')
      expect(response.status).to eq(403)
    end

    it 'allows access to an audit report that a user owns' do
      session[:user_id] = user1.id

      put :edit, audit_report_id: audit_report.id

      expect(response.status).to eq(200)
    end
  end

  describe '#update' do
    it 'does not allow access to an audit report that a user does not own' do
      session[:user_id] = user2.id

      put :update,
          audit_report_id: audit_report.id,
          audit_report: { report_template_id: 1 }

      expect(response.body).to eq('')
      expect(response.status).to eq(403)
    end

    it 'allows access to an audit report that a user owns' do
      session[:user_id] = user1.id

      put :update,
          audit_report_id: audit_report.id,
          audit_report: { report_template_id: 1 }

      expect(response.status).to eq(302)
    end
  end

  describe '#show' do
    it 'does not allow access to an audit report that a user does not own' do
      session[:user_id] = user2.id

      put :show, audit_report_id: audit_report.id

      expect(response.body).to eq('')
      expect(response.status).to eq(403)
    end

    it 'allows access to an audit report that a user owns' do
      session[:user_id] = user1.id

      put :show, audit_report_id: audit_report.id

      expect(response.status).to eq(200)
    end
  end

  describe '#preview' do
    it 'does not allow access to an audit report that a user does not own' do
      session[:user_id] = user2.id

      put :preview,
          audit_report_id: audit_report.id,
          audit_report: { report_template_id: 1 },
          content_block: { 'text' => 'my text' }

      expect(response.body).to eq('')
      expect(response.status).to eq(403)
    end

    it 'allows access to an audit report that a user owns' do
      session[:user_id] = user1.id

      put :preview,
          audit_report_id: audit_report.id,
          audit_report: { report_template_id: 1 },
          content_block: { 'text' => 'my text' }

      expect(response.status).to eq(200)
    end
  end
end
