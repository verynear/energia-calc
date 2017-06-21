require 'rails_helper'

describe StructureMulticloneService do
  let(:existing_structure) { instance_double(AuditStructure) }

  it 'makes a single copy of a structure' do
    should_clone 'Foo structure'
    described_class.execute!(
      n_copies: 1,
      pattern: 'Foo structure',
      audit_structure: existing_structure
    )
  end

  it 'makes multiple copies with a letter wildcard' do
    should_clone 'Foo structure A'
    should_clone 'Foo structure B'
    described_class.execute!(
      n_copies: 2,
      pattern: 'Foo structure ?',
      audit_structure: existing_structure
    )
  end

  it 'makes multiple copies with a numeric wildcard' do
    should_clone 'Foo structure 1'
    should_clone 'Foo structure 2'
    described_class.execute!(
      n_copies: 2,
      pattern: 'Foo structure #',
      audit_structure: existing_structure
    )
  end

  def should_clone(new_name)
    expect(StructureCloneService)
      .to receive(:execute!)
      .with(params: { name: new_name },
            audit_structure: existing_structure)
      .once
  end
end
