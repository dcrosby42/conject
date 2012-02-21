module Conject

  class ObjectDefinition
    attr_reader :component_names, :owner 

    def initialize(opts={})
      @owner = opts[:owner]
      @component_names = opts[:component_names] || []
    end
  end
end
