describe 'StructureDetailController' do
  before do
    create_audit_with_details unless Audit.count > 0
    structure = StructureDetailPresenter.new(Audit.first.structure)
    controller = StructureDetailController.alloc.init
    Field.sort_by(:display_order).all.to_a[0..2].each do |field|
      FieldValue.create_with_uuid(field_id: field.id,
                                  structure_id: structure.id,
                                  string_value: field.storage_type)
      cdq.save
    end

    controller.structure = structure
    self.controller = controller
  end

  after do
    cdq.reset!
  end

  tests StructureDetailController

  describe 'show' do
    it 'shows fields that are on the generated form' do
      controller.form.sections[0].rows.count.should == 2
      controller.form.sections[1].rows.count.should == 12
      form = controller.form.render
      Field.sort_by(:display_order).all.to_a[0..2].each do |field|
        form[field.id].should == 'string_value'
      end
    end

    it 'turns off editing if the audit is locked' do
      audit = Audit.first
      user = User.create
      audit.locked_by = user.id

      controller.form.sections.each do |section|
        section.rows.each do |row|
          row.editable.should == false
        end
      end
    end
  end
end
