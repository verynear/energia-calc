class AuditMeasuresPresenter < Decorator
  def form
    rows = []
    Measure.active.sort_by(&:name).each do |measure|
      on = false
      notes = nil
      if measure_value = get_measure_value(measure)
        on = measure_value.boolean_value
        notes = measure_value.notes
      end

      rows << { title: measure.name,
                key: measure.id,
                display_key: :type,
                type: :measure,
                value: on,
                subform: { title: "Measure Notes: #{measure.name}",
                           sections: [ { rows: [{ key: measure.id,
                                                  type: :text,
                                                  row_height: 500,
                                                  value: notes },
                                                { title: 'Back',
                                                  type: :back }] }] } }
    end.flatten

    { sections: [{ rows: rows }] }
  end
end
