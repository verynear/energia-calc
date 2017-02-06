class CloneSubstructureController < UIViewController
  extend IB
  include BaseController

  attr_accessor :substructure

  outlet :substructure_description, UILabel
  outlet :name_pattern, UITextField
  outlet :count_field, UITextField
  outlet :cancel_button, UIBarButtonItem
  outlet :create_substructure_button

  def viewDidLoad
    substructure_description.text = substructure.short_description
    self.name_pattern.text = substructure.name
    self.count_field.text = '1'
  end

  def clone(sender)
    count = 1
    count_field.text.to_i.times do
      StructureCloneService.execute!(structure: substructure,
                                     params: { name: patterned_name(count) })
      count += 1
    end
    cdq.save
    close_popover
  end

  def patterned_name(count)
    pattern_text = name_pattern.text.dup
    if pattern_text.include?('?')
      pattern_text.gsub!('?', letters[(count-1)%26])
    elsif pattern_text.include?('#')
      pattern_text.gsub!('#', count.to_s)
    end
    pattern_text
  end

  def letters
    @letters ||= ('A'..'Z').to_a
  end

  def cancel(sender)
    close_popover
  end

  def close_popover
    NSNotificationCenter
      .defaultCenter
      .postNotificationName('dismissPopover', object: self)
  end
end
