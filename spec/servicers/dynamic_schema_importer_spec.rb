require 'rails_helper'

describe DynamicSchemaImporter do
  let(:audit_type) { AuditStrcType.find_by(name: 'Audit') }

  before(:all) do
    described_class.execute!
  end

  after(:all) do
    # DatabaseCleaner doesn't handle this spec very well, so clear out the
    # database to prevent order-dependent failures.
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end

  specify 'imports the correct number of records' do
    expect(AuditStrcType.count).to eq 209
    expect(AuditField.count).to eq 1984
  end

  specify 'creates a top level structure type' do
    expect(AuditStrcType.where(parent_structure_type_id: nil).count).to eq 1
  end

  specify 'structure types can have child types' do
    expect(audit_type.child_structure_types.pluck(:name).sort).to eq [
      'Building',
      'Common Area',
      'Cooling System',
      'Domestic Hot Water System',
      'Heating System',
      'Meter']
  end

  specify 'structure types can have types' do
    meter_type = AuditStrcType.find_by(name: 'Meter', primary: false)
    expect(meter_type.child_structure_types.pluck(:name).sort).to eq [
      'Electric',
      'Gas',
      'Oil',
      'Water']
  end

  specify 'structure types can have types and subtypes' do
    hs_type = AuditStrcType.find_by(name: 'Heating System', primary: false)
    expect(hs_type.child_structure_types.pluck(:name).sort).to eq [
      'Cogeneration',
      'Controls',
      'Distribution System',
      'Electric Resistance',
      'Forced Air',
      'Heat Pump',
      'Hydronic',
      'Steam']

    child_type = hs_type.child_structure_types.find_by(name: 'Hydronic', primary: true)
    expect(child_type.child_structure_types.pluck(:name).sort).to eq [
      'Electric',
      'Gas',
      'Oil',
      'Other']
  end

  specify 'structure types have groupings' do
    expect(audit_type.groupings.pluck(:name).sort).to eq [
      'Audit',
      'Auditor',
      'General',
      'Management Company',
      'Owner Info',
      'Property Information']
  end

  specify 'groupings have fields' do
    grouping = Grouping.find_by(name: 'Auditor')
    expect(grouping.audit_fields.pluck(:name, :value_type)).to eq [
      ['Name', 'string'],
      ['Email Address', 'email'],
      ['Phone Number', 'phone']]
  end

  specify 'fields have the correct types' do
    expect(AuditField.all.uniq.pluck(:value_type).sort).to eq [
      'check',
      'date',
      'decimal',
      'email',
      'integer',
      'phone',
      'picker',
      'state',
      'string',
      'switch',
      'text']
  end

  specify 'pickers have field enumerables' do
    picker = AuditField.find_by(name: 'Burner Type', value_type: 'picker')
    expect(picker.field_enumerations.pluck(:value).sort).to eq [
      'Atmospheric',
      'Forced Draft (power)',
      'Sealed Combustion']
  end

  specify 'multi-picklists import as separate check fields' do
    multi_picklist = Grouping.find_by(name: 'Insulation Location')
    expect(multi_picklist.audit_fields.pluck(:name, :value_type)).to eq [
      ['Wall', 'check'],
      ['Ceiling', 'check'],
      ['None', 'check']]
  end

  specify 'a notes field is created for every structure type' do
    AuditStrcType.where(primary: true).each do |audit_strc_type|
      general_grouping = audit_strc_type.groupings.find_by_name('General')
      expect(general_grouping).to be_present
      expect(general_grouping.audit_fields.where(name: 'Notes').count).to eq 1
    end
  end
end
