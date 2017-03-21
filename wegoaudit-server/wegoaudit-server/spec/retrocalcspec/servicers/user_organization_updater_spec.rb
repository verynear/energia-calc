require 'rails_helper'

describe UserOrganizationUpdater do
  let(:user) { create(:user) }
  let(:updater) { described_class.new(user: user) }
  let(:client) { instance_double(WegowiseClient) }

  before do
    allow(WegowiseClient).to receive(:new).and_return(client)
  end

  describe '#execute' do
    context 'when wegowise returns an organization' do
      let(:response) do
        [
          {
            'id' => 12,
            'name' => 'pandas',
            'owner' => {
              'id' => 20,
              'username' => 'testpanda'
            }
          }
        ]
      end

      before do
        allow(client).to receive(:organizations).and_return(response)
      end

      it 'creates the organization if necessary' do
        updater.execute
        expect(Organization.count).to eq 1

        organization = Organization.find_by(wegowise_id: 12)
        expect(organization.name).to eq 'pandas'
      end

      it 'updates an existing organization' do
        create(:organization, name: 'old', wegowise_id: 12)

        expect { updater.execute }.to_not change { Organization.count }
        organization = Organization.find_by(wegowise_id: 12)
        expect(organization.name).to eq 'pandas'
      end

      it 'associates user with organization' do
        updater.execute

        organization = Organization.find_by(wegowise_id: 12)
        expect(user.organization).to eq organization
      end
    end

    context 'when wegowise returns an empty list' do
      let(:organization) { create(:organization) }

      before do
        user.update!(organization: organization)
        allow(client).to receive(:organizations).and_return []
      end

      it 'removes user from organization' do
        expect { updater.execute }.to change { user.reload.organization_id }
          .from(organization.id).to(nil)
      end

      it 'does not delete or update organizations' do
        expect { updater.execute }.to_not change { organization }
      end
    end
  end
end
