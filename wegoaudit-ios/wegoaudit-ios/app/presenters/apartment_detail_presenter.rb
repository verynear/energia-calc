class ApartmentDetailPresenter < StructureDetailPresenter
  def base_form
    { sections: structure_sections + apartment_sections }
  end

  def apartment_sections
    [
      {
        rows: [
          { title: 'Number of bedrooms', key: 'n_bedrooms', type:'number', value: physical_structure.n_bedrooms },
          { title: 'Square Footage', key: 'sqft', type:'number', value: physical_structure.sqft },
          { title: 'Unit Number', key: 'unit_number', type:'string', value: physical_structure.unit_number }
        ]
      }
    ]
  end
end
