# Original idea for this approach taken from:
# https://github.com/joshuaclayton/basic_decorator
#
# The decorator should delegate almost everything to the base object. This
# includes the `class`, but not `==`, since a decorated object is not actually
# the same as the base object, and will behave differently.

class Decorator
  attr_reader :component

  instance_methods.each do |m|
    undef_method(m) if m.to_s !~
      /(?:^__|^==$|object_id|send|caller|tap|component)/
  end

  def self.inherited(klass)
    klass.class_eval %(
      def decorator_class
        #{klass.name}
      end
      )
  end

  def initialize(component)
    @component = component
  end

  def method_missing(name, *args, &block)
    @component.public_send(name, *args, &block)
  end

  def respond_to?(method_name, include_all = false)
    super(method_name, include_all)
  end

  def respond_to_missing?(method_name, include_all = false)
    @component.respond_to?(method_name, include_all) || super
  end

  def self.const_missing(name)
    ::Object.const_get name
  end
end
