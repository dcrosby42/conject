PROJECT_ROOT = File.expand_path(File.dirname(__FILE__) + "/..")

$LOAD_PATH << "#{PROJECT_ROOT}/lib"
ENV["APP_ENV"] = "rspec"

require 'object_context'

# require 'mocha'
# RSpec.configure do |config|
#   config.mock_with :mocha
# end


# Load all support files
Dir["#{PROJECT_ROOT}/spec/support/*.rb"].each do |support|
  require support
end

