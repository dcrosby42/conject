# Object Context #

Retrieve and relate objects within contexts.  Provides dependency injection convenience inspired by the simplicity of Google's Guice.

# Basic composition #

Declare required component objects for a class using .construct_with


    require 'conject'

    class Wood
      def to_s; "Wood"; end
    end

    class Nails
      def to_s; "Nails"; end
    end

    class Fence
      construct_with :wood, :nails

      def to_s
        "I'm made of #{wood} and #{nails}"
      end
    end

    fence = Conject.default_object_context.get(:fence)
    puts fence
    #=> "I'm made of Wood and Nails"

# Configuring objects #

Call #configure_object or #configure_objects to configure one or more objects wrt
their construction or handling. 

* :cache [true|false] - Enable/disable object caching in context.  If false, a new instance is created for every request for an object with the given name. Default true.
* :construct [Proc|Lambda] - Anonymous function to call to provide the named object.  Will be cached like any other object, subject to :cache configuration for this context.

    context.configure_objects({
      :wood => { :cache => false },
      :nails => { :construct => lambda do "The nails" end},
    })
    # context[:wood] != context[:wood]
    # context[:nails] == "The nails"

# Modules as namespaces #

    module Chart
      class Presenter
        construct_with 'chart/model', 'chart/view'

        def to_s
          "I'm a Chart::Presenter composed of a #{model} and a #{view}"
        end
      end
    end

# Subcontexts #

    first_fence = nil
    second_fence = nil

    Conject.default_object_context.in_subcontext do |sub|
      first_fence = sub[:fence]
    end

    Conject.default_object_context.in_subcontext do |sub|
      second_fence = sub[:fence]
    end

    # second_fence != first_fence

