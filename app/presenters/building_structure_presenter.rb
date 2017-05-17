class BuildingStructurePresenter < Decorator
  def as_json
    h = audit_structure.attributes
    h[:physical_structure] = self.attributes
    h
  end
end
