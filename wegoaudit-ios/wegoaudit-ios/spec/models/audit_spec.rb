describe 'Audit' do
  before do
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a Audit entity' do
    Audit.entity_description.name.should == 'Audit'
  end

  describe '.list_all' do
    it 'returns unarchived audits first' do
      create_audits

      audits = Audit.list_all.to_a
      audits.slice(0..9).each do |audit|
        audit.is_archived.should == 0
      end

      audits.slice(10..20).each do |audit|
        audit.is_archived.should == 1
      end
    end
  end

  describe '#is_locked?' do
    it 'returns true if the audit has been locked by a user' do
      user = find_or_create_user
      audit = Audit.new(locked_by: user.id)
      audit.is_locked?.should == true
    end

    it 'returns false if the audit has not been locked' do
      audit = Audit.new(locked_by: nil)
      audit.is_locked?.should == false
    end
  end

  describe '#locked_by_user' do
    it 'returns the user that locked an audit' do
      user = find_or_create_user
      audit = Audit.new(locked_by: user.id)
      audit.locked_by_user.should == user
    end
  end

  describe '#set_measure_value' do
    it 'creates a new measure value record' do
      audit = Audit.create_with_uuid
      measure = Measure.create_with_uuid
      MeasureValue.count.should == 0
      audit.set_measure_value(measure.id, true, 'bar')
      MeasureValue.count.should == 1
      measure_value = audit.get_measure_value(measure)
      measure_value.boolean_value.should == true
      measure_value.notes.should == 'bar'
    end

    it 'updates an existing measure value record' do
      audit = Audit.create_with_uuid
      measure = Measure.create_with_uuid
      MeasureValue.create_with_uuid(
        measure_id: measure.id,
        audit_id: audit.id,
        value: true,
        notes: 'bar'
      )
      measure_value = audit.get_measure_value(measure)
      measure_value.boolean_value.should == true
      measure_value.notes.should == 'bar'
      MeasureValue.count.should == 1
      audit.set_measure_value(measure.id, false, 'baz')
      MeasureValue.count.should == 1
      measure_value = audit.get_measure_value(measure)
      measure_value.boolean_value.should == false
      measure_value.notes.should == 'baz'
    end

    it 'does nothing if the measure does not exist' do
      audit = Audit.create_with_uuid
      audit.set_measure_value('foo', true, 'bar')
      audit.measure_values.length.should == 0
    end
  end
end
