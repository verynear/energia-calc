require 'rails_helper'

describe QueueOrganizationBuildingsService do
  describe '#execute!' do
    it 'queues a worker for each organization' do
      2.times { create(:organization) }
      QueueOrganizationBuildingsService.execute!
      expect(OrganizationBuildingRetrievalWorker.jobs.size).to eq 2
    end

    it 'finds an authenticated member if the owner has not authenticated' do
      organization = create(:organization)
      organization.owner.update(token: nil)
      user = create(:user)
      organization.memberships.create(user_id: user.id,
                                      role: Organization::MEMBER)

      QueueOrganizationBuildingsService.execute!
      expect(OrganizationBuildingRetrievalWorker.jobs.size).to eq 1
    end

    it 'does not queue a worker if no users have authenticated' do
      organization = create(:organization)
      organization.owner.update(token: nil)
      user = create(:user, token: nil)
      organization.memberships.create(user_id: user.id,
                                      role: Organization::MEMBER)
      QueueOrganizationBuildingsService.execute!
      expect(OrganizationBuildingRetrievalWorker.jobs.size).to eq 0
    end
  end
end
