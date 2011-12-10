require 'ruice/inflector'
require 'ruice/context'

module Ruice
  class << self
    def [](key)
      Ruice.global_context.get(key)
    end

    def global_context
      @global_context ||= Context.build
    end
  end


end

