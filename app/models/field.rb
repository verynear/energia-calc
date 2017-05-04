class Field < ActiveRecord::Base
  include WegoauditObjectLookup

  has_many :field_values

  validates :name, presence: true
  validates :api_name, uniqueness: true, presence: true
  validates :value_type, presence: true

  def convert_value(val)
    return if val == '' || val.nil?

    case value_type
    when 'string', 'picker' then val.to_s
    when 'decimal' then BigDecimal.new(val)
    when 'integer' then val.to_i
    when 'date' then val.to_datetime
    when 'switch'
      if val == 'true'
        true
      else
        false
      end
    end
  end
end
