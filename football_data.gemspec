# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'football_data/version'

Gem::Specification.new do |gem|
  gem.name          = "football_data"
  gem.version       = FootballData::VERSION
  gem.authors       = ["Michael Hoitomt"]
  gem.email         = ["mike.hoitomt@gmail.com"]
  gem.description   = %q{Get all available spread data for NFL and college games}
  gem.summary       = %q{Goes out to covers.com and scrapes the data}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "datamapper"
  gem.add_dependency "dm-postgres-adapter"
  gem.add_dependency "dm-cli"
  gem.add_dependency "nokogiri"
end
