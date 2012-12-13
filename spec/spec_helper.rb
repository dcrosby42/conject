require 'simplecov' # SimpleCov must come first!
# This start/config code could alternatively go in .simplecov in project root:
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/borrowed_active_support_inflector.rb" # We stole it precious, our specs only hit about 47% of the functions, just to prove we have this library ready to go
end

PROJECT_ROOT = File.expand_path(File.dirname(__FILE__) + "/..")

$LOAD_PATH << "#{PROJECT_ROOT}/lib"
$LOAD_PATH << "#{PROJECT_ROOT}/spec/samples"
ENV["APP_ENV"] = "rspec"

require 'conject'

require 'pry'

# Load all support files
Dir["#{PROJECT_ROOT}/spec/support/*.rb"].each do |support|
  require support
end

RSpec.configure do |config|
  config.include LoadPathHelpers
  config.include ConjectHelpers
end

