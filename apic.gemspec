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
  s.description = "APIc is a bolt on API console for Rails 3+ applications. It rounds up your endpoints and makes it dead easy to configure, send, review and replay any request."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.require_paths = ['lib']

  s.add_dependency "rails", ">= 3.2.0"
  s.add_dependency "coffee-rails"

end
