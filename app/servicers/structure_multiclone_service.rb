class StructureMulticloneService < BaseServicer
  LETTERS = ('A'..'Z').to_a

  attr_accessor :n_copies,
                :pattern,
                :audit_structure

  attr_reader :cloned_structures

  def execute!
    1.upto(n_copies) do |count|
      StructureCloneService.execute!(
        params: { name: patterned_name(count) },
        audit_structure: audit_structure
      )
    end
  end

  private

  def patterned_name(count)
    if pattern.include?('?')
      pattern.gsub('?', LETTERS[(count - 1) % 26])
    elsif pattern.include?('#')
      pattern.gsub('#', count.to_s)
    else
      pattern
    end
  end
end
