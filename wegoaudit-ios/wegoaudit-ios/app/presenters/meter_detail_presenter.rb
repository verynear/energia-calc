class MeterDetailPresenter < StructureDetailPresenter
  def base_form
    { sections: structure_sections + meter_sections }
  end

  def meter_sections
    [
      {
        title: 'Meter',
        rows: [
          { title: 'Data Type', key: 'data_type', type: 'picker', value: physical_structure.data_type, items: meter_types },
          { title: 'Account Number', key: 'account_number', type: 'string', value: physical_structure.account_number },
          { title: 'Utility Company Name', key: 'utility_company_name', type: 'string', value: utility_company_name_value },
          { title: 'Status', key: 'status', type: 'static', value: physical_structure.status },
          { title: 'Coverage', key: 'coverage', type: 'picker', value: physical_structure.coverage, items: coverage_types },
          { title: 'For heating?', key: 'for_heating', type: 'switch', value: physical_structure.for_heating },
          { title: 'Number of buildings', key: 'n_buildings', type: 'number', value: physical_structure.n_buildings },
          { title: 'Tenant pays?', key: 'tenant_pays', type: 'switch', value: physical_structure.tenant_pays },
          { title: 'Notes', key: 'notes', type: 'text', value: physical_structure.notes }
        ]
      }
    ]
  end

  def utility_company_name_value
    physical_structure.utility_company_name || physical_structure.other_utility_company
  end

  def meter_types
    %w[Gas Electric Water Oil Steam Propane Solar]
  end

  def coverage_types
    %w[all common  apartment area  none]
  end
end
