class Measure < ActiveRecord::Base
  include ApiNameGeneration

  before_create :generate_api_name

  has_many :measure_values

  validates :name, presence: true

  validate :validate_unchanged_api_name

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end
