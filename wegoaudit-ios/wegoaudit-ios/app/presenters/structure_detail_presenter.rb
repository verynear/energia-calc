class StructureDetailPresenter < Decorator
  def base_form
    {
      sections: structure_sections
    }
  end

  def form
    f = base_form
    f[:sections] += generated_form[:sections]
    f
  end

  private

  def structure_sections
    [{
      title: 'Structure',
      rows: structure_rows
    }]
  end

  def structure_rows
    rows = [{
      title: 'Name',
      key: :name,
      type: :required_string,
      auto_correction: :no,
      value: name
    }]

    if has_subtype?
      rows.concat([
        {
          title: 'Type',
          type: :static,
          value: structure_type.parent_structure_type.name
        },
        {
          title: 'Subtype',
          type: :static,
          value: structure_type.name
        }
      ])
    else
      rows << {
        title: 'Type',
        type: :static,
        value: structure_type.name
      }
    end
  end

  def has_subtype?
    structure_type.parent_structure_type && structure_type.parent_structure_type.is_subtype?
  end
end
