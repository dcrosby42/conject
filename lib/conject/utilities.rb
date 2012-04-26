module Conject
  module Utilities 
    class << self
      def has_zero_arg_constructor?(klass)
        init_arity = klass.instance_method(:initialize).arity
        init_arity == 0 or (RUBY_VERSION <= "1.9.2" and init_arity == -1)
      end

      def generate_accessor_method_name(object_name)
        object_name.to_s.split("/").last.to_sym
      end
    end
  end
end
