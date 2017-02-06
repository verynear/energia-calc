class AttributeCopierService < BaseServicer
  attr_accessor :from,
                :to

  def execute!
    raise ArgumentError unless to.class == from.class
    to.set_attributes(from.cloneable_attributes)
  end
end
