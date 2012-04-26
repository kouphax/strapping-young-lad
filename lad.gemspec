# -*- encoding: utf-8 -*-
require File.expand_path('../lib/lad/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["James Hughes"]
  gem.email         = ["james@yobriefca.se"]
  gem.description   = %q{Strapping Young Lad: Project Template Bootstrapper}
  gem.summary       = %q{Template generator and token switcher}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "lad"
  gem.require_paths = ["lib"]
  gem.version       = Lad::VERSION

  gem.add_dependency('git')
  gem.add_dependency('colorize')

  gem.add_development_dependency('minitest')
  gem.add_development_dependency('rake')
end
