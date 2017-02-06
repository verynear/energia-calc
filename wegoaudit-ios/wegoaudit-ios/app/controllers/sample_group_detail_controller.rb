class SampleGroupDetailController < Formotion::FormController
  include AppDelegateTools
  include DisableContentReadableMargins

  attr_accessor :form,
                :sample_group

  def form
    return @form if @form
    @form = Formotion::Form.new(sample_group.form)

    @form.sections.each do |section|
      section.rows.each do |row|
        row.editable = can_edit_current_audit?

        row.on_end do
          row.object.validate!
        end
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
    if can_edit_current_audit?
      data = @form.render

      @form.sections.each do |section|
        section.rows.each do |row|
          row.object.validate!
        end
      end

      data.each do |key, value|
        sample_group.set_value(key, value)
      end

      cdq.save
    end
  end
end
