# Object Context #

Retrieve and relate objects within contexts.  Provides dependency injection convenience inspired by the simplicity of Google's Guice.

# Basic composition #

Declare required component objects for a class using .construct_with

```ruby
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
```
# Configuring objects #

Call #configure_object or #configure_objects to configure one or more objects wrt
their construction or handling. 

* :cache [true|false] - Enable/disable object caching in context.  If false, a new instance is created for every request for an object with the given name. Default true.
* :construct [Proc|Lambda] - Anonymous function to call to provide the named object.  Will be cached like any other object, subject to :cache configuration for this context.

Eg.
    context.configure_objects({
      :wood => { :cache => false },
      :nails => { :construct => lambda do "The nails" end},
    })
    # context[:wood] != context[:wood]
    # context[:nails] == "The nails"

# Modules as namespaces #

```ruby
module Chart
  class Presenter
    construct_with 'chart/model', 'chart/view'

    def to_s
      "I'm a Chart::Presenter composed of a #{model} and a #{view}"
    end
  end
end
```
# Subcontexts #

```ruby
first_fence = nil
second_fence = nil

Conject.default_object_context.in_subcontext do |sub|
  first_fence = sub[:fence]
end

Conject.default_object_context.in_subcontext do |sub|
  second_fence = sub[:fence]
end

# second_fence != first_fence
```
If you'd like to ensure that certain dependencies needed by objects built in subcontexts are actually housed in the parent context, but they
have not necessarily been cached or injected in advance, AND you've got an "owner"-like object living in that context, you can declare 
object peers within the class definition of that owner object.  This ensures that collaborators in the subcontext will not cause the peer
objects to be instantiated in those subcontexts as well. 

```ruby
class Game
  object_peers: :missile_coordinator, :wind_affector
end
```

In this example, the instantiation of a Game instance in an object context will cause missile coordinator and wind affector to be "anchored"
in the same context as the game instance, meaning they prefer to be instantiated here, if needed by any objects in this same context or any
subcontexts thereof.  It also means that they will be preferred over any objects of the same name in a super context.

# My ObjectContext #

All classes built within an ObjectContext are able to reference the context directly via the private accessor method "#object_context", which 
is available as early as the call to #initialize.

# Aliasing #
The following will cause one object to be fulfilled by another.  In this case, 'album' is not expected to be built
as an instance of the Album class, but rather will be set up as another name for 'and_justice_for_all':

```ruby
context.configure_objects album: { is: 'and_justice_for_all' }
```

Both 'album' and 'and_justice_for_all' will be built in the context when 'album' is first requested.
This is more or less expressive shorthand for:

```ruby
context['album'] = context['and_justice_for_all'] 
```

...EXCEPT that it's a lazy approach: using 'is' means nothing actually gets built or set in the context before it
is requested or composed into another object.

# Specialization via Composition#

To declare objects as instances of a specific class, you may specify the :class of the object via #configure_objects.
Furthermore, you can specialize the instance by indicating which specific objects you would like to supply as the object's collaborators:

```ruby
context.configure_objects({
  adventure_time: {
    class: Team, 
    specialize: { 
      hero: "finn",
      sidekick: "jake" }},
  dark_knight: {
    class: Team,
    specialize: {
      hero: "batman",
      sidekick: "robin" }}
})
```

The keys in :specialize match some or all of the keys defined in the class (in this case, the Team class is defined to be #construct_with :hero, :sidekick, :clock.
The values are object names within the ObjectContext; they will be resolved in the usual manner.
Components that a Class wants to be built with, but which you omit from the :specialize Hash, will be resolved in the usual way.

Using :class and :specialize is NOT THE SAME as building objects within a subcontext.  Objects mentioned here are expected to be found and kept within the defining ObjectContext.
