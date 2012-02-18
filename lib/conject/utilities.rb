module Conject::Utilities 
  class << self
    def has_zero_arg_constructor?(klass)
      init_arity = klass.instance_method(:initialize).arity
      init_arity == 0 or (RUBY_VERSION <= "1.9.2" and init_arity == -1)
    end
  end
end
