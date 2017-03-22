module CalcMeasuresHelper
  def options_for_measures(measures)
    options_for_select(measures.map { |measure| [measure.name, measure.id] })
  end
end
