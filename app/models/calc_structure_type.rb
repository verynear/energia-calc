class CalcStructureType < ActiveRecord::Base
  include WegoauditObjectLookup

  validates :name, presence: true
  validates :api_name, uniqueness: true, presence: true

  def genus_structure_type
    CalcStructureType.by_api_name!(genus_api_name)
  end
end
