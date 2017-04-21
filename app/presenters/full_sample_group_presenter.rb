class FullSampleGroupPresenter < Decorator
  def as_json
    h = attributes
    h['substructures'] = substructures_array
    h
  end

  private

  def substructures_array
    substructures.map do |substructure|
      FullStructurePresenter.new(substructure).as_json
    end
  end
end
