class StructureDetailsPresenter
  attr_reader :structure

  def initialize(structure)
    @structure = structure
  end

  def groupings
    @groupings ||= ordered_groupings.map do |grouping|
      StructureGroupingPresenter.new(structure, grouping)
    end
  end

  private

  def ordered_groupings
    structure
      .structure_type
      .groupings
      .order(:display_order)
  end
end
