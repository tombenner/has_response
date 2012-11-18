$:.push File.expand_path("../lib", __FILE__)

require "has_response/version"

Gem::Specification.new do |s|
  s.name        = "has_response"
  s.version     = HasResponse::VERSION
  s.authors     = ["Tom Benner"]
  s.email       = ["tombenner@gmail.com"]
  s.homepage    = "https://github.com/tombenner/has_response"
  s.summary     = "Extremely simple API support for Rails models"
  s.description = "Extremely simple API support for Rails models"

  s.files = `git ls-files`.split("\n")#Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.7"
end
