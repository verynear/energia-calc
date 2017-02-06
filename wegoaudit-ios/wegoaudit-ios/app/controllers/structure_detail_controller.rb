class StructureDetailController < Formotion::FormController
  include AppDelegateTools
  include DisableContentReadableMargins

  attr_accessor :form,
                :structure

  def form
    return @form if @form
    @form = Formotion::Form.new(structure.form)

    @form.sections.each do |section|
      section.rows.each do |row|
        row.editable = can_edit_structure?

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
    if can_edit_structure?
      data = @form.render

      @form.sections.each do |section|
        section.rows.each do |row|
          row.object.validate!
        end
      end

      data.each do |key, value|
        structure.set_field_value(key, value)
      end

      cdq.save
    end
  end

  private

  def can_edit_structure?
    return physical_structure.linked? if physical_structure.respond_to?(:linked?)
    can_edit_current_audit?
  end

  def physical_structure
    structure.physical_structure
  end
end
