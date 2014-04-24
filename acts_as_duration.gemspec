$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_duration/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_duration"
  s.version     = ActsAsDuration::VERSION
  s.authors     = ["Yonah Forst"]
  s.email       = ["yonaforst@hotmail.com"]
  s.homepage    = "github.com/joshblour/acts_as_duration"
  s.summary     = "attr_accessor that automatically converts between duration units"
  s.description = "adds getter and setters for an existing attribute to covnert between seconds, minutes, hours, and days"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.3"

  s.add_development_dependency "sqlite3"
end
