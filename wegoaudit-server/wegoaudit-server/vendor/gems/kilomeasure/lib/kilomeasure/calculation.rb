module Kilomeasure
  class Calculation < ObjectBase
    fattrs :errors,
           :measure,
           :name,
           :result

    attr_reader :value

    def initialize(*)
      super
      self.errors ||= []
      @value = result unless errors.any?
    end
  end
end
