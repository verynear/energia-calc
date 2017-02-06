class SubstructureSearchResultCell < UITableViewCell
  extend IB

  attr_accessor :substructure_type

  outlet :name, UILabel

  def update(substructure = nil)
    self.substructure = substructure
    name.text = substructure.name
  end
end
