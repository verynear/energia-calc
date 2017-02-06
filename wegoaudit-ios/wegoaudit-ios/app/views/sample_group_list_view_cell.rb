class SampleGroupListViewCell < UITableViewCell
  extend IB

  attr_accessor :sample_group

  outlet :name, UILabel

  def update(sample_group = nil)
    self.sample_group = sample_group
    name.text = sample_group.long_description
  end
end
