class StructureDetailsPresenter
  attr_reader :audit_structure

  def initialize(audit_structure)
    @audit_structure = audit_structure
  end

  def groupings
    @groupings ||= ordered_groupings.map do |grouping|
      StructureGroupingPresenter.new(audit_structure, grouping)
    end
  end

  private

  def ordered_groupings
    audit_structure
      .audit_strc_type
      .groupings
      .order(:display_order)
  end
end
