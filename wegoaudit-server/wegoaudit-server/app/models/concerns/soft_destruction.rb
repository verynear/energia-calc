module SoftDestruction
  extend ActiveSupport::Concern

  included do
    scope :active, -> do
      where(destroy_attempt_on: nil)
    end

    scope :destroyed, -> do
      where.not(destroy_attempt_on: nil)
    end
  end

  module ClassMethods
  end

  def soft_destroy
    touch(:destroy_attempt_on)
  end
end
