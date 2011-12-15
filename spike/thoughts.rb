# REGULAR OBJECT
# Instance of some class with 0 or more components
#
#


# Object definitions
#   Manually add to context by name
#   Indirectly added to context by meta programming in concerned class
#   Generated defaults
#
# If no def exists 
#   if require_on_demand is true
#     require guessed library name
#   if def still not exist
#     generate default def
#
# Use def to construct object
#   
#   ? when a class uses meta programming to define aspects of itself
#   we are not yet in a context for certain.
#   We could assume global context but that isn't always right.
#
#   REAL QUESTION:
#     How do we define non-global contexts conveniently?
#     :w
#

