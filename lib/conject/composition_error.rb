require 'set'

module Conject
  class CompositionError < ArgumentError
    def initialize(opts=nil)
      opts ||= {}
      object_def = opts[:object_definition]
      required = nil
      required = object_def.component_names if object_def
      provided = opts[:provided] || []

      msg = "Unexpected CompositionError"

      if object_def.nil?
        msg = "Failed to construct... something."
        if provided and !provided.empty? 
          msg << " Provided objects were: #{provided.inspect}"
        end

      elsif object_def and required and provided
        owner = object_def.owner || "object"
        msg = "Wrong components when building new #{owner}."

        missing = required - provided
        msg << " Missing required object(s) #{missing.to_a.inspect}." unless missing.empty?

        unexpected = provided - required
        msg << " Unexpected object(s) provided #{unexpected.to_a.inspect}." unless unexpected.empty?

      end

      super msg
    end
  end
end
