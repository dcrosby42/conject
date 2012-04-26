# Object Context #

Retrieve and relate objects within contexts.  Provides dependency injection convenience inspired by the simplicity of Google's Guice.

# Example: Basic composition #

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

# Example: Modules as namespaces #

    module Chart
      class Presenter
        construct_with 'chart/model', 'chart/view'

        def to_s
          "I'm a Chart::Presenter composed of a #{model} and a #{view}"
        end
      end
    end

