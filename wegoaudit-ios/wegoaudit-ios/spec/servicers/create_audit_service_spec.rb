describe 'CreateAuditService' do
  before do
    cdq.setup

    @audit_type = AuditType.create_with_uuid(name: 'Test AuditType')
    @structure_type = StructureType.create_with_uuid(name: 'Audit')
    @user = User.create
  end

  after do
    cdq.reset!
  end

  describe 'execute' do
    it 'creates a new audit' do
      audit = create_audit('Test Audit')
      audit.should.not == nil
    end

    it 'assigns the audit type from the audit type name' do
      audit = create_audit('Test Audit')
      audit.audit_type_id.should == @audit_type.id
    end

    it 'creates an initial audit structure for the audit' do
      audit = create_audit('Test Audit')
      audit.structure.should.not == nil
      audit.structure.structure_type.should == @structure_type
    end

    it 'converts the performed_on timestamp' do
      audit = create_audit('Test Audit')
      audit.performed_on.class.should == Time
      audit.performed_on.year.should == 2014
      audit.performed_on.month.should == 12
      audit.performed_on.day.should == 30
    end

    it 'gives the user a lock on the new audit' do
      audit = create_audit('Test Audit')
      audit.locked_by.should == @user.id
    end

    def create_audit(name)
      params = {
        name: name,
        audit_type: 'Test AuditType',
        performed_on: 1419979720
      }
      CreateAuditService.execute!(audit: params, user: @user)
      Audit.where(name: 'Test Audit').first
    end
  end
end
