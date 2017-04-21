class RenameCogenerationAndVentilationMeasures < ActiveRecord::Migration
  class Measure < ActiveRecord::Base; end

  def up
    cogeneration = Measure.find_by(name: 'Cogeneration')
    cogeneration.update_columns(
      name: 'Install Cogeneration System',
      api_name: 'install_cogeneration_system'
    ) if cogeneration

    ventilation = Measure.find_by(name: 'Ventilation')
    ventilation.update_columns(
      name: 'Upgrade Ventilation System',
      api_name: 'upgrade_ventilation_system'
    ) if ventilation
  end

  def down
    cogeneration = Measure.find_by(name: 'Install Cogeneration System')
    cogeneration.update_columns(
      name: 'Cogeneration',
      api_name: 'cogeneration'
    ) if cogeneration

    ventilation = Measure.find_by(name: 'Upgrade Ventilation System')
    ventilation.update_columns(
      name: 'Ventilation',
      api_name: 'ventilation'
    ) if ventilation
  end
end
