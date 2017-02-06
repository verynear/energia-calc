class NewSampleController < UIViewController
  extend IB
  include BaseController

  attr_accessor :sample_group

  outlet :type, UIPickerView
  outlet :sub_type, UIPickerView
  outlet :label_type, UILabel
  outlet :label_sub_type, UILabel
  outlet :name, UITextField
  outlet :create_sample_button

  def viewDidLoad
    super

    self.type.dataSource = self
    self.type.delegate = self
    self.sub_type.dataSource = self
    self.sub_type.delegate = self
  end

  def viewWillAppear(animated)
    super
    @substructure_types = structure_type.child_structure_types.to_a

    if @substructure_types.first
      @selectable_types = @substructure_types.first.child_structure_types.to_a
    else
      @selectable_types = []
    end

    if has_no_types?
      hide_type
      hide_sub_type
    else
      show_type
      if @selectable_types.length > 0
        show_sub_type
      else
        hide_sub_type
      end
    end

    self.title = "New #{structure_type.name} for #{sample_group.name}"
  end

  def numberOfComponentsInPickerView(pickerView)
    1
  end

  def pickerView(pickerView, numberOfRowsInComponent: component)
    if pickerView == type
      @substructure_types.count
    else
      @selectable_types.count
    end
  end

  def pickerView(pickerView, titleForRow: index, forComponent: component)
    if pickerView == type
      @substructure_types[index].name
    else
      @selectable_types[index].name
    end
  end

  def pickerView(pickerView, didSelectRow: row, inComponent: component)
    if pickerView == type
      @selectable_types = selected_type_children
      if @selectable_types.length > 0
        sub_type.reloadAllComponents
        show_sub_type
      else
        hide_sub_type
      end
    else
      name.text = selected_type.name if name.text.length == 0
    end
  end

  def create_sample(sender)
    SampleCreationService.execute!(
      params: { name: self.name.text },
      structure_type: chosen_type,
      sample_group: sample_group)

    cdq.save
    dismiss_modal
  end

  def chosen_type
    return selected_sub_type unless @sub_type_hidden
    return selected_type unless @type_hidden
    return structure_type
  end

  def hidden?(pickerView)
    pickerView.window.nil?
  end

  def show_sub_type
    @sub_type_hidden = false
    label_sub_type.hidden = true
    sub_type.hidden = false
  end

  def hide_sub_type
    @sub_type_hidden = true
    label_sub_type.text = 'None'
    label_sub_type.hidden = false
    sub_type.hidden = true
  end

  def show_type
    @type_hidden = false
    self.type.hidden = false
    self.label_type.hidden = true
  end

  def hide_type
    @type_hidden = true
    type.hidden = true
    label_type.text = structure_type.name
    label_type.hidden = false
  end

  def selected_type
    return structure_type if has_no_types?
    @substructure_types[self.type.selectedRowInComponent(0)]
  end

  def selected_sub_type
    return structure_type if has_no_types?
    @selectable_types[self.sub_type.selectedRowInComponent(0)]
  end

  def selected_type_children
    selected_type.child_structure_types.to_a
  end

  def dismiss_modal
    dismissModalViewControllerAnimated(true)
  end

  def has_no_types?
    structure_type.primary == 1
  end

  def structure_type
    sample_group.structure_type
  end
end
