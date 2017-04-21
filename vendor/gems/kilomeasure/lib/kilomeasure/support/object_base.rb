class ObjectBase
  include BooleanAttr
  include Memoizer # rubocop:disable Wego/ImplicitMemoizer

  def initialize(**attributes)
    attributes.each do |key, value|
      public_send("#{key}=", value)
    end
  end
end
