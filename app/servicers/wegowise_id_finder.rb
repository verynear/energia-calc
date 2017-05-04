# This class is given an array of structures, and is responsible for finding
# wegowise_ids for physical structures (including nested ones).
#
class WegowiseIdFinder < Generic::Strict
  attr_accessor :structures,
                :wegowise_ids

  def initialize(structures)
    @structures = structures
  end

  def find_ids
    @wegowise_ids = {
      'building' => { ids: [] },
      'apartment' => { ids: [] },
      'meter' => { ids: [] }
    }
    extract_wegowise_ids(structures, wegowise_ids)
    wegowise_ids
  end

  def find_ids_and_names
    @wegowise_ids = {
      'building' => { ids: [], names: [] },
      'apartment' => { ids: [], names: [] },
      'meter' => { ids: [], names: [] }
    }
    extract_wegowise_ids(structures, wegowise_ids, true)
    wegowise_ids
  end

  private

  def extract_wegowise_ids(structures, wegowise_ids, include_names = false)
    structures.each do |structure|
      wegowise_id = structure['wegowise_id']

      if wegowise_id.present? && wegowise_id != 0
        structure_type = structure['structure_type']['api_name']
        structure_type = 'apartment' if structure_type == 'apartments_units'

        wegowise_ids[structure_type][:ids] << wegowise_id
        if include_names
          wegowise_ids[structure_type][:names] << structure['name']
        end
      end

      substructures = structure['substructures'] || []
      extract_wegowise_ids(substructures, wegowise_ids, include_names)
    end
  end
end
