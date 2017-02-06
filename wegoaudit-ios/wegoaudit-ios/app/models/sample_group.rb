class SampleGroup < CDQManagedObject
  include CDQRecord

  synchronization_attribute :id

  scope :not_destroyed, where(destroy_attempt_on: nil)

  def can_have_substructures?
    true
  end

  def can_add_samples?
    substructures.length < n_structures
  end

  def short_description
    name
  end

  def form
    {
      sections: [
        {
          title: 'Sample Group',
          rows: [
            {
              title: 'Name',
              key: :name,
              type: :required_string,
              auto_correction: :no,
              value: name
            },
            {
              title: 'Sample Size',
              key: :n_structures,
              type: :number,
              value: n_structures
            }
          ]
        }
      ]
    }
  end

  def long_description
    "#{structure_type.name} - #{name} (#{substructures.length} of #{n_structures})"
  end

  def name=(str)
    super(str.to_s)
  end

  def n_structures=(int)
    super(int.to_i)
  end

  def parent_structure
    Structure.where(id: parent_structure_id).first
  end

  def presenter
    SampleGroupDetailPresenter.new(self)
  end

  def set_value(key, value)
    public_send("#{key}=", value)
  end

  def substructures
    Structure.where(sample_group_id: id)
  end

  def structure_type
    StructureType.where(id: structure_type_id).first
  end
end
