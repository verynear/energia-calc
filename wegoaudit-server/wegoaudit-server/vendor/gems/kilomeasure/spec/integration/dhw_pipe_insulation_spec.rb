require 'kilomeasure'

describe 'dhw pipe insulation' do
  include_examples 'measure', 'dhw_pipe_insulation'

  context 'example 1' do
    let!(:before_inputs) do
      {
        afue: 0.71,
        dhw_btu_per_hour: 398_000,
        tank_efficiency: 0.8,
        length_uninsulated_pipe: 400,
        length_insulated_pipe: 0
      }
    end

    let!(:after_inputs) do
      {
        afue: 0.71,
        tank_efficiency: 0.8,
        length_uninsulated_pipe: 0,
        length_insulated_pipe: 400,
        dhw_pipe_insulation_cost: 3600
      }
    end

    let!(:shared_inputs) do
      {
        number_fires_per_day: 24,
        number_heater_days_per_year: 365,
        heating_fuel_baseload_in_therms: 4654.96,
        outer_pipe_diameter_in_inches: 1.05,
        # pipe_material: 'copper',
        # temperature_outside_pipes: 50,
        # temperature_inside_pipes: 130,
        r_value_of_pipe_insulation: 4.5,
        gas_cost_per_therm: 1
      }
    end

    it { should_get_gas_savings(379.8) } # should be 383
    it { should_get_cost_savings(379.8) } # should be 383
    it { should_get_cost_of_measure(3600) }
    it { should_get_years_to_payback(9.5) } # 9.4

    context 'intermediate calculations' do
      # it do
        # should_get_component_field_value(
          # :water_flowing_percentage,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 0.133515)
      # end
      # it do
        # should_get_component_field_value(
          # :average_length_each_fire,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 8)
      # end
      # it do
        # should_get_component_field_value(
          # :time_between_calls,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 52)
      # end
      # it do
        # should_get_component_field_value(
          # :inner_volume_uninsulated_pipes,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 10.97)
      # end
      # it do
        # should_get_component_field_value(
          # :volume_uninsulated_pipes,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 0.94)
      # end
      # it do
        # should_get_component_field_value(
          # :uninsulated_pipe_surface_area,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 109.9) # document says 110
      # end
      # it do
        # should_get_component_field_value(
          # :weight_uninsulated_pipes,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 522.65)
      # end
      # it do
        # should_get_component_field_value(
          # :temperature_when_dhw_fires_again_uninsulated,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 50)
      # end
      # it do
        # should_get_component_field_value(
          # :energy_lost_per_fire_uninsulated,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 7194) # document says 7110
      # end
      # it do
        # should_get_component_field_value(
          # :energy_lost_per_year_uninsulated,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 630.1) # document says 623
      # end
      # it do
        # should_get_component_field_value(
          # :heat_loss_rate_of_uninsulated_pipes,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 20_230.2) # document says 20231.9
      # end
      # it do
        # should_get_component_field_value(
          # :loss_from_uninsulated_pipes,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 236.6)
      # end
      # it do
        # should_get_component_field_value(
          # :total_stagnant_loss,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 630.1) # document says 622.9
      # end
      # it do
        # should_get_component_field_value(
          # :total_flowing_loss,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 236.6)
      # end
      # it do
        # should_get_component_field_value(
          # :total_loss,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 866.8) # document says 859.5
      # end
      # it do
        # should_get_component_field_value(
          # :energy_factor,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 0.57)
      # end
      # it do
        # should_get_component_field_value(
          # :energy_to_pipes,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 2_644)
      # end
      # it do
        # should_get_component_field_value(
          # :energy_to_tenants,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 1777.2) # 1784.52
      # end

      # it do
        # should_get_component_field_value(
          # :inner_volume_insulated_pipes,
          # after_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 10.97)
      # end
      # it do
        # should_get_component_field_value(
          # :volume_insulated_pipes,
          # after_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 0.94)
      # end
      # it do
        # should_get_component_field_value(
          # :weight_insulated_pipes,
          # after_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 522.65)
      # end
      # it do
        # should_get_component_field_value(
          # :insulated_pipe_surface_area,
          # after_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 109.9) # 110
      # end
      # it do
        # should_get_component_field_value(
          # :temperature_when_dhw_fires_again_insulated,
          # after_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 50.02)
      # end
      # it do
        # should_get_component_field_value(
          # :energy_lost_per_fire_insulated,
          # after_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 7194)
      # end
      # it do
        # should_get_component_field_value(
          # :heat_loss_rate_of_insulated_pipes,
          # after_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 1782.4)
      # end
      # it do
        # should_get_component_field_value(
          # :total_stagnant_loss,
          # after_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 630.19) # 622.7
      # end
      # it do
        # should_get_component_field_value(
          # :total_stagnant_loss,
          # after_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 630.19) # 622.7
      # end
      # it do
        # should_get_component_field_value(
          # :total_loss_proposed,
          # after_inputs.merge(shared_inputs).merge(
            # dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour],
            # afue_existing: after_inputs[:afue],
            # energy_to_pipes_existing: 2_644,
            # total_flowing_loss_existing: 235.6
          # ),
          # 649.3) # 641.9
      # end
      # it do
        # should_get_component_field_value(
          # :energy_to_pipes,
          # after_inputs.merge(shared_inputs).merge(
            # dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour],
            # afue_existing: after_inputs[:afue],
            # energy_to_pipes_existing: 2_644,
            # total_flowing_loss_existing: 235.6
          # ),
          # 2644) # 2426
      # end
      # it do
        # should_get_component_field_value(
          # :energy_factor,
          # after_inputs.merge(shared_inputs).merge(
            # dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour],
            # afue_existing: after_inputs[:afue],
            # energy_to_pipes_existing: 2_644,
            # total_flowing_loss_existing: 235.6
          # ),
          # 0.57)
      # end
      # it do
        # should_get_component_field_value(
          # :heating_fuel_baseload_in_therms_proposed,
          # after_inputs.merge(shared_inputs).merge(
            # dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour],
            # afue_existing: before_inputs[:afue],
            # energy_to_pipes_existing: 2_644,
            # energy_to_pipes_proposed: 2904.69,
            # total_flowing_loss_existing: 235.6
          # ),
          # 5113.8) # 4272
      # end
    end
  end

  context 'example 2' do
    let!(:before_inputs) do
      {
        afue: 0.78,
        dhw_btu_per_hour: 199_000,
        tank_efficiency: 0.8,
        length_uninsulated_pipe: 130,
        length_insulated_pipe: 250
      }
    end

    let!(:after_inputs) do
      {
        afue: 0.78,
        tank_efficiency: 0.8,
        length_uninsulated_pipe: 0,
        length_insulated_pipe: 380,
        dhw_pipe_insulation_cost: 2250
      }
    end

    let!(:shared_inputs) do
      {
        number_fires_per_day: 24,
        number_heater_days_per_year: 365,
        heating_fuel_baseload_in_therms: 7856,
        outer_pipe_diameter_in_inches: 1.05,
        # pipe_material: 'copper',
        # temperature_outside_pipes: 50,
        temperature_inside_pipes: 145,
        r_value_of_pipe_insulation: 4.5,
        gas_cost_per_therm: 1
      }
    end

    it { should_get_gas_savings(450.4) } # should be 460
    it { should_get_cost_savings(450.4) } # should be 460
    it { should_get_cost_of_measure(2250) }
    it { should_get_years_to_payback(5.0) }

    context 'intermediate calculations' do
      # it do
        # should_get_component_field_value(
          # :water_flowing_percentage,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 0.4507)
      # end
      # it do
        # should_get_component_field_value(
          # :average_length_each_fire,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 27.04)
      # end
      # it do
        # should_get_component_field_value(
          # :time_between_calls,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 32.96)
      # end
      # it do
        # should_get_component_field_value(
          # :inner_volume_uninsulated_pipes,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 3.57)
      # end
      # it do
        # should_get_component_field_value(
          # :volume_uninsulated_pipes,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 0.3)
      # end
      # it do
        # should_get_component_field_value(
          # :uninsulated_pipe_surface_area,
          # before_inputs.merge(shared_inputs),
          # 35.5) # should be 35.7
      # end

      # it do
        # should_get_component_field_value(
          # :weight_uninsulated_pipes,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 169.86)
      # end
      # it do
        # should_get_component_field_value(
          # :temperature_when_dhw_fires_again_uninsulated,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 50)
      # end
      # it do
        # should_get_component_field_value(
          # :temperature_when_dhw_fires_again_insulated,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 50) # document says 50.428
      # end
      # it do
        # should_get_component_field_value(
          # :energy_lost_per_fire_uninsulated,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 2776.4) # document says 2744
      # end
      # it do
        # should_get_component_field_value(
          # :energy_lost_per_fire_insulated,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 5339.3) # document says 5253
      # end
      # it do
        # should_get_component_field_value(
          # :energy_lost_per_year_uninsulated,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 243.2) # document says 240
      # end
      # it do
        # should_get_component_field_value(
          # :energy_lost_per_year_insulated,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 467.7) # document says 460
      # end
      # it do
        # should_get_component_field_value(
          # :heat_loss_rate_of_uninsulated_pipes,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 7776.6) # document says 7808.2
      # end
      # it do
        # should_get_component_field_value(
          # :heat_loss_rate_of_insulated_pipes,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
        # 1317.6) # document says 1323
      # end
      # it do
        # should_get_component_field_value(
          # :loss_from_uninsulated_pipes,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 307) # document says 308.2
      # end
      # it do
        # should_get_component_field_value(
          # :loss_from_insulated_pipes,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 52.0) # document says 52.2
      # end
      # it do
        # should_get_component_field_value(
          # :total_stagnant_loss,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 630.1) # document says 622.9
      # end
      # it do
        # should_get_component_field_value(
          # :total_flowing_loss,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 359.0) # document says 360.5
      # end
      # it do
        # should_get_component_field_value(
          # :total_loss,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 865.8) # document says 859.5
      # end
      # it do
        # should_get_component_field_value(
          # :energy_factor,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 0.57)
      # end
      # it do
        # should_get_component_field_value(
          # :energy_to_pipes,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 2_644)
      # end
      # it do
        # should_get_component_field_value(
          # :energy_to_tenants,
          # before_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 1778.1) # 1784.52
      # end

      # it do
        # should_get_component_field_value(
          # :inner_volume_insulated_pipes,
          # after_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 10.97)
      # end
      # it do
        # should_get_component_field_value(
          # :volume_insulated_pipes,
          # after_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 0.94)
      # end
      # it do
        # should_get_component_field_value(
          # :weight_insulated_pipes,
          # after_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 522.65)
      # end
      # it do
        # should_get_component_field_value(
          # :insulated_pipe_surface_area,
          # after_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 109.5) # 110
      # end
      # it do
        # should_get_component_field_value(
          # :temperature_when_dhw_fires_again_insulated,
          # after_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 50.02)
      # end
      # it do
        # should_get_component_field_value(
          # :energy_lost_per_fire_insulated,
          # after_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 7194)
      # end
      # it do
        # should_get_component_field_value(
          # :heat_loss_rate_of_insulated_pipes,
          # after_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 1775.4) # 1782.5
      # end
      # it do
        # should_get_component_field_value(
          # :total_stagnant_loss,
          # after_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 630.19) # 622.7
      # end
      # it do
        # should_get_component_field_value(
          # :total_stagnant_loss,
          # after_inputs.merge(shared_inputs)
          # .merge(dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour]),
          # 630.19) # 622.7
      # end
      # it do
        # should_get_component_field_value(
          # :total_loss_proposed,
          # after_inputs.merge(shared_inputs).merge(

            # dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour],
            # afue_existing: after_inputs[:afue],
            # energy_to_pipes_existing: 2_644,
            # total_flowing_loss_existing: 235.6
          # ),
          # 844.2) # 641.9
      # end
      # it do
        # should_get_component_field_value(
          # :energy_to_pipes,
          # after_inputs.merge(shared_inputs).merge(
            # dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour],
            # afue_existing: after_inputs[:afue],
            # energy_to_pipes_existing: 2_644,
            # total_flowing_loss_existing: 235.6
          # ),
          # 4615) # 2426
      # end
      # it do
        # should_get_component_field_value(
          # :energy_factor,
          # after_inputs.merge(shared_inputs).merge(
            # dhw_btu_per_hour_existing: before_inputs[:dhw_btu_per_hour],
            # afue_existing: after_inputs[:afue],
            # energy_to_pipes_existing: 2_644,
            # total_flowing_loss_existing: 235.6
          # ),
          # 0.57)
      # end
    end
  end
end
