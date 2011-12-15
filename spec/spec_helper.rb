$LOAD_PATH << File.join(File.dirname(__FILE__), '../lib')
ENV["APP_ENV"] = "rspec"

#require 'environment'

# require 'mocha'
# RSpec.configure do |config|
#   config.mock_with :mocha
# end


# Load all support files
Dir["#{APP_ROOT}/spec/support/*.rb"].each do |support|
  require support
end

