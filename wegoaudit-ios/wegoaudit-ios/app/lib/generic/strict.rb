module Generic
  class Strict
    def initialize(attributes = nil)
      self.attributes = attributes if attributes
    end

    def attributes=(attributes)
      attributes.each do |k, v|
        if respond_to?(:"#{k}=")
        then public_send(:"#{k}=", v)
        else raise ArgumentError, "unknown attribute: #{k}"
        end
      end
    end
  end
end
