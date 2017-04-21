module BooleanAttr
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def boolean_attr_accessor(*args)
      options = args.extract_options!
      boolean_attr_writer(*args, options)

      attr_reader(*args)
      args.each { |arg| alias_method "#{arg}?".to_sym, arg.to_sym }

      @boolean_attributes ||= []
      @boolean_attributes += args
    end

    def boolean_attr_writer(*args)
      options = args.extract_options!

      args.each do |attribute|
        define_method "#{attribute}=" do |value|
          result =
            if [true, 'true', 1, '1'].include?(value)
              true
            elsif !options[:allow_nil] && [nil, ''].include?(value)
              nil
            else
              false
            end

          instance_variable_set "@#{attribute}", result
        end
      end
    end

    # note that a subclass won't be able to automatically introspect the
    # boolean attributes defined in parent classes. One would need to loop
    # through ancestors to find that out separately.
    def boolean_attributes
      @boolean_attributes
    end
  end
end
