module Conject
  module Utilities 
    class << self
      def has_zero_arg_constructor?(klass)
        init_arity = klass.instance_method(:initialize).arity
        init_arity == 0 or (RUBY_VERSION <= "1.9.2" and init_arity == -1)
      end

      def generate_accessor_method_names(object_name)
        parts = object_name.to_s.split("/").reject do |x| x == "" end
        [ parts.join("_").to_sym, parts.last.to_sym ].uniq
      end

      # (LIFTED FROM ActiveSupport::Inflector)
      # By default, +camelize+ converts strings to UpperCamelCase. If the argument to +camelize+
      # is set to <tt>:lower</tt> then +camelize+ produces lowerCamelCase.
      #
      # +camelize+ will also convert '/' to '::' which is useful for converting paths to namespaces.
      #
      # Examples:
      #   "active_record".camelize                # => "ActiveRecord"
      #   "active_record".camelize(:lower)        # => "activeRecord"
      #   "active_record/errors".camelize         # => "ActiveRecord::Errors"
      #   "active_record/errors".camelize(:lower) # => "activeRecord::Errors"
      #
      # As a rule of thumb you can think of +camelize+ as the inverse of +underscore+,
      # though there are cases where that does not hold:
      #
      #   "SSLError".underscore.camelize # => "SslError"
      def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
        if first_letter_in_uppercase
          lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
        else
          lower_case_and_underscored_word.to_s[0].chr.downcase + camelize(lower_case_and_underscored_word)[1..-1]
        end
      end

      # (LIFTED FROM ActiveSupport::Inflector)
      # Makes an underscored, lowercase form from the expression in the string.
      #
      # Changes '::' to '/' to convert namespaces to paths.
      #
      # Examples:
      #   "ActiveRecord".underscore         # => "active_record"
      #   "ActiveRecord::Errors".underscore # => active_record/errors
      #
      # As a rule of thumb you can think of +underscore+ as the inverse of +camelize+,
      # though there are cases where that does not hold:
      #
      #   "SSLError".underscore.camelize # => "SslError"
      def underscore(camel_cased_word)
        word = camel_cased_word.to_s.dup
        word.gsub!(/::/, '/')
        word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word
      end
    end
  end
end
