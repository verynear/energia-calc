# This class is given an array of structures, and is responsible for finding
# wegowise_ids for physical structures (including nested ones).
#
class WegowiseIdFinder < Generic::Strict
  attr_accessor :calc_structures,
                :wegowise_ids

  def initialize(structures)
    @calc_structures = calc_structures
  end

  def find_ids
    @wegowise_ids = {
      'building' => { ids: [] },
      'apartment' => { ids: [] },
      'meter' => { ids: [] }
    }
    extract_wegowise_ids(calc_structures, wegowise_ids)
    wegowise_ids
  end

  def find_ids_and_names
    @wegowise_ids = {
      'building' => { ids: [], names: [] },
      'apartment' => { ids: [], names: [] },
      'meter' => { ids: [], names: [] }
    }
    extract_wegowise_ids(calc_structures, wegowise_ids, true)
    wegowise_ids
  end

  private

  def extract_wegowise_ids(calc_structures, wegowise_ids, include_names = false)
    calc_structures.each do |calc_structure|
      wegowise_id = calc_structure['wegowise_id']

      if wegowise_id.present? && wegowise_id != 0
        calc_structure_type = calc_structure['structure_type']['api_name']
        calc_structure_type = 'apartment' if calc_structure_type == 'apartments_units'

        wegowise_ids[calc_structure_type][:ids] << wegowise_id
        if include_names
          wegowise_ids[calc_structure_type][:names] << calc_structure['name']
        end
      end

      substructures = calc_structure['substructures'] || []
      extract_wegowise_ids(substructures, wegowise_ids, include_names)
    end
  end
end
