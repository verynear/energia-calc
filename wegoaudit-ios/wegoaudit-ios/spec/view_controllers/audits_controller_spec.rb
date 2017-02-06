describe 'AuditsController' do
  tests AuditsController, storyboard: 'Main', id: 'auditsController'

  before do
    cdq.setup

    @mock_user = mock('User', id: 'foo')
    UIApplication.sharedApplication.delegate.stub!(:current_user).and_return(@mock_user)
    create_audits
    controller.reload_audits
  end

  after do
    controller.clear_notifications
    cdq.reset!
  end

  describe 'listing' do
    it 'lists audits' do
      controller.view.visibleCells.count.should == 20
    end

    it 'shows the users last_name, first_name' do
      controller.view.visibleCells[0].user.text.should == 'Smith, Joseph'
    end

    it 'shows audit lock status' do
      controller.view.visibleCells.each do |c|
        %w[locked unlocked].should.include c.lock_image.accessibilityIdentifier
      end
    end

    it 'shows the updated_at' do
      audit = Audit.list_all.first
      controller.view.visibleCells[0].date.text
        .should == audit.performed_on.strftime("%d %b %y")
    end

    it 'shows the Audit name' do
      controller.view.visibleCells[0].name.text.should == 'Audit (19)'
    end
  end
end
