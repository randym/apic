$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "apic/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "apic"
  s.version     = Apic::VERSION
  s.authors     = ["Randy Morgan"]
  s.email       = ["digital.ipseity@gmail.com"]
  s.homepage    = "https://github.com/randym/apic/"
  s.summary     = "Apic is a mountable rails engine that enables a web based console for testing api endpoints."
  s.description = s.summary
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "slim-rails", "~>2.0.1"
  s.add_dependency "sass-rails", ">= 3.2"
  s.add_dependency "bootstrap-sass", "~>2.3.2.2"
  s.add_dependency "coffee-rails"
  s.add_dependency "jquery-rails"
end
