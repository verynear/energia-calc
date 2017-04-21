require 'features_helper'

feature 'reorder measures in report', :js do
  include Features::CommonSupport
  include Features::AuditReportSupport
  include Features::WebSupport

  let!(:user) { create(:user) }
  let!(:dhw) do
    create(:structure_type,
           name: 'DHW',
           api_name: 'domestic_hot_water_system',
           genus_api_name: 'domestic_hot_water_system')
  end
  let!(:distribution_system) do
    create(:structure_type,
           name: 'Distribution System',
           api_name: 'distribution_system',
           genus_api_name: 'distribution_system')
  end
  let!(:measure1) do
    create(:measure, name: 'DHW', api_name: 'test_dhw_replacement')
  end
  let!(:measure2) do
    create(:measure,
           name: 'Pipe Insulation',
           api_name: 'test_dhw_pipe_insulation')
  end

  before do
    setup_measures
  end

  scenario 'reordering measures changes per-measure values' do
    add_new_structure('DHW - White House', dhw.api_name)
    fill_out_structure_cards(
      '1 - DHW',
      existing: { afue: 0.7, tank_efficiency: 0.8 },
      proposed: {
        afue: 0.92, tank_efficiency: 0.8, per_unit_cost: 9380 }
    )
    fill_out_measure_level_fields(retrofit_lifetime: '20')

    select_measure_tab(measure2.name)
    add_new_structure(
      'Distribution system - White House',
      distribution_system.api_name)
    fill_out_structure_cards(
      '1 - Distribution System',
      existing: { spec_r_value: 1, length_pipe: 1_000 },
      proposed: { spec_r_value: 5, length_pipe: 1_000, per_unit_cost: 1 }
    )
    fill_out_measure_level_fields(retrofit_lifetime: '20')

    click_link 'Edit report data'
    fill_out_audit_level_fields(
      gas_cost_per_therm: 1,
      heating_fuel_baseload_in_therms: 2061.20)
    click_link 'Edit measures'

    select_measure_tab(measure1.name)
    expect_measure_summary_values(
      annual_cost_savings: '$492.90',
      annual_gas_savings: '493.0',
      years_to_payback: '19.0',
      cost_of_measure: '$9,380.00',
      savings_investment_ratio: '1.05'
    )

    # Try adding another DHW
    open_add_new_structure_modal
    should_see_modal('Choose structure to replace') do
      expect(page).to have_content(
        'No remaining available structures for this measure.')
    end

    select_measure_tab(measure2.name)
    expect_measure_summary_values(
      annual_cost_savings: '$800.00',
      annual_gas_savings: '800',
      years_to_payback: '0.0013',
      cost_of_measure: '$1.00',
      savings_investment_ratio: '16000.0'
    )

    # Try adding another structure - only distribution system is available
    open_add_new_structure_modal
    should_see_modal('Choose structure to replace') do
      expect_structure_options(
        api_name: 'distribution_system',
        options: ['Distribution system - White House', 'New structure...']
      )
    end

    expect_measure_tabs(measure1.name, measure2.name)
    drag_and_drop(".js-measure-tab:contains('#{measure1.name}')",
                  ".js-measure-tab:contains('#{measure2.name}')")
    expect_measure_tabs(measure2.name, measure1.name)

    select_measure_tab(measure1.name)
    expect_measure_summary_values(
      annual_cost_savings: '$301.59',
      annual_gas_savings: '302.0',
      years_to_payback: '31.1',
      cost_of_measure: '$9,380.00',
      savings_investment_ratio: '0.643'
    )

    select_measure_tab(measure2.name)
    expect_measure_summary_values(
      annual_cost_savings: '$800.00',
      annual_gas_savings: '800',
      years_to_payback: '0.0013',
      cost_of_measure: '$1.00',
      savings_investment_ratio: '16000.0'
    )
  end

  scenario 'reordering measures with multiple structure changes' do
    add_new_structure('DHW - White House', dhw.api_name)
    fill_out_structure_cards(
      '1 - DHW',
      existing: { afue: 0.7, tank_efficiency: 0.8 },
      proposed: {
        afue: 0.92, tank_efficiency: 0.8, per_unit_cost: 9380 }
    )
    fill_out_measure_level_fields(retrofit_lifetime: '20')

    select_measure_tab(measure2.name)
    add_new_structure(
      'Distribution system - White House',
      distribution_system.api_name)
    fill_out_structure_cards(
      '1 - Distribution System',
      existing: { spec_r_value: 1, length_pipe: 1_000 },
      proposed: { spec_r_value: 5, length_pipe: 1_000, per_unit_cost: 1 }
    )

    add_new_structure(
      'Distribution system - White House',
      distribution_system.api_name)
    fill_out_structure_cards(
      '2 - Distribution System',
      existing: { spec_r_value: 1, length_pipe: 1_000 },
      proposed: { spec_r_value: 5, length_pipe: 1_000, per_unit_cost: 1 }
    )
    fill_out_measure_level_fields(retrofit_lifetime: '20')

    click_link 'Edit report data'
    fill_out_audit_level_fields(
      gas_cost_per_therm: 1,
      heating_fuel_baseload_in_therms: 2061.20)
    click_link 'Edit measures'

    select_measure_tab(measure1.name)
    expect_measure_summary_values(
      annual_cost_savings: '$492.90',
      annual_gas_savings: '493.0',
      years_to_payback: '19.0',
      cost_of_measure: '$9,380.00',
      savings_investment_ratio: '1.05'
    )

    select_measure_tab(measure2.name)
    expect_measure_summary_values(
      annual_cost_savings: '$1,600.00',
      annual_gas_savings: '1,600',
      years_to_payback: '0.0025',
      cost_of_measure: '$2.00',
      savings_investment_ratio: '16000.0'
    )

    expect_measure_tabs(measure1.name, measure2.name)
    drag_and_drop(".js-measure-tab:contains('#{measure1.name}')",
                  ".js-measure-tab:contains('#{measure2.name}')")
    expect_measure_tabs(measure2.name, measure1.name)

    select_measure_tab(measure2.name)
    expect_measure_summary_values(
      annual_cost_savings: '$1,600.00',
      annual_gas_savings: '1,600',
      years_to_payback: '0.0025',
      cost_of_measure: '$2.00',
      savings_investment_ratio: '16000.0'
    )

    select_measure_tab(measure1.name)
    expect_measure_summary_values(
      annual_cost_savings: '$110.29',
      annual_gas_savings: '110.0',
      years_to_payback: '85.1',
      cost_of_measure: '$9,380.00',
      savings_investment_ratio: '0.235'
    )
  end

  def setup_measures
    create(:field,
           name: 'afue',
           api_name: 'afue',
           value_type: 'decimal')
    create(:field,
           name: 'tank_efficiency',
           api_name: 'tank_efficiency',
           value_type: 'decimal')
    create(:field,
           name: 'R-value',
           api_name: 'spec_r_value',
           value_type: 'decimal')
    create(:field,
           name: 'DHW pipe length',
           api_name: 'length_pipe',
           value_type: 'decimal')
    create(:field,
           name: 'Per unit cost',
           api_name: 'per_unit_cost',
           value_type: 'decimal')

    Field.unmemoize_all

    Kilomeasure.add_measure(
      'test_dhw_replacement',
      data_types: %w[gas water_heating],
      inputs: [
        :gas_cost_per_therm,
        :afue,
        :tank_efficiency,
        :per_unit_cost
      ],
      formulas: {
        energy_factor:
          'afue * tank_efficiency',
        energy_factor_existing:
          'afue_existing * tank_efficiency_existing',
        energy_to_pipes_existing:
          'heating_fuel_baseload_in_therms * energy_factor_existing',
        annual_gas_usage_existing:
          'heating_fuel_baseload_in_therms',
        annual_gas_usage_proposed:
          'energy_to_pipes_existing / energy_factor',
        annual_gas_usage:
          'IF(proposed, annual_gas_usage_proposed, annual_gas_usage_existing)',
        annual_operating_cost:
          'annual_gas_cost',
        retrofit_cost:
          'per_unit_cost'
      }
    )

    MeasureDefinitionsRegistry.add_definition(
      'test_dhw_replacement',
      inputs: {
        audit: [
          :gas_cost_per_therm
        ],
        domestic_hot_water_system: [
          :afue,
          :tank_efficiency,
          :per_unit_cost
        ]
      }
    )

    Kilomeasure.add_measure(
      'test_dhw_pipe_insulation',
      data_types: %w[gas water_heating],
      inputs: [
        :gas_cost_per_therm,
        :length_pipe,
        :spec_r_value,
        :per_unit_cost
      ],
      formulas: {
        energy_loss:
        'length_pipe * 1 / spec_r_value', # NB: this is a nonsense formula
        annual_gas_usage:
        '500 + energy_loss',
        annual_operating_cost:
        'annual_gas_cost',
        retrofit_cost:
        'per_unit_cost'
      }
    )

    MeasureDefinitionsRegistry.add_definition(
      'test_dhw_pipe_insulation',
      inputs: {
        audit: [
          :gas_cost_per_therm
        ],
        distribution_system: [
          :length_pipe,
          :spec_r_value,
          :per_unit_cost
        ]
      },
      structures: {
        distribution_system: {
          multiple: true
        }
      }
    )

    set_up_audit_report_for_measures(
      [measure1, measure2],
      user: user,
      substructures: [
        { name: 'DHW', structure_type: dhw },
        { name: 'Distribution system', structure_type: distribution_system }
      ]
    )
  end
end
