# -*- encoding: utf-8 -*-
require File.expand_path('../lib/conject/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["David Crosby"]
  gem.email         = ["david.crosby@atomicobject.com"]
  gem.description   = %q{Enable Guice-like dependency injection and contextual object interactions.}
  gem.summary       = %q{Enable Guice-like dependency injection and contextual object interactions.}
  gem.homepage      = "https://github.com/dcrosby42/conject"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n") - [".gitignore", ".rspec", ".rvmrc", "NOTES.txt", "TODO"]
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "conject"
  gem.require_paths = ["lib"]
  gem.version       = Conject::VERSION

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "pry"
end
