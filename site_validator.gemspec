# -*- encoding: utf-8 -*-
require File.expand_path('../lib/site_validator/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jaime Iniesta"]
  gem.email         = ["jaimeiniesta@gmail.com"]
  gem.description   = %q{command-line tool to validate the markup of a whole site against the W3C validator}
  gem.summary       = %q{command-line tool to validate the markup of a whole site against the W3C validator}
  gem.homepage      = "http://gem.sitevalidator.com/"
  gem.license       = "MIT"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {spec}/*`.split("\n")
  gem.name          = "site_validator"
  gem.require_paths = ["lib"]
  gem.version       = SiteValidator::VERSION

  gem.add_dependency 'w3c_validators',  '~> 1.2'
  gem.add_dependency 'metainspector',   '~> 4.6'

  gem.add_development_dependency 'rspec',   '~> 2.14.1'
  gem.add_development_dependency 'mocha',   '~> 0.11.4'
  gem.add_development_dependency 'rake',    '~> 10.1.0'
  gem.add_development_dependency 'fakeweb', '~> 1.3.0'
end
