class CalcStructure < ActiveRecord::Base
  belongs_to :structure_change
  has_many :calc_field_values, as: :parent
  has_many :calc_fields, through: :calc_field_values

  delegate :wegoaudit_structure, to: :structure_change
  delegate :measure_selection, to: :structure_change
  delegate :sample_group?, to: :wegoaudit_structure

  def audit_report
    @audit_report ||= structure_change.measure_selection.audit_report
  end

  def belongs_to_user?(user)
    audit_report.user == user
  end

  def existing?
    !proposed?
  end

  def original_name
    wegoaudit_structure.description
  end

  def original_quantity
    wegoaudit_structure.n_structures
  end
end
