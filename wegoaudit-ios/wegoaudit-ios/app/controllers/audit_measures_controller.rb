class AuditMeasuresController < Formotion::FormController
  include AppDelegateTools
  include DisableContentReadableMargins

  attr_accessor :form,
                :structure

  def form
    return @form if @form
    @form = Formotion::Form.new(AuditMeasuresPresenter.new(current_audit).form)

    @form.sections.each do |section|
      section.rows.each do |row|
        row.editable = can_edit_current_audit?
      end
    end

    @form
  end

  def viewDidLoad
    form
    super
  end

  def viewWillDisappear(animated)
    save
  end

  def save
    return unless can_edit_current_audit?

    form.sections.each do |section|
      section.rows.each do |row|
        next if row.subform.nil?
        notes = row.subform.to_form.render.values.first
        current_audit.set_measure_value(row.key, row.value, notes)
      end
    end

    cdq.save
  end
end
