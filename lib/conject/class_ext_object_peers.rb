require 'conject/utilities'
class Class
  def object_peers(*syms)
    if !syms.empty?
      @_conject_object_peers = syms
    end
    @_conject_object_peers || []
  end
end
