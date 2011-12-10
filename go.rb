$LOAD_PATH << "lib"
$LOAD_PATH << "src"

require 'ruice'

presenter = Ruice[:user_presenter]
model = Ruice[:user_model]
view = Ruice[:user_view]

model.user = { :name => "Dave" }
puts "view.name=#{view.name}"
