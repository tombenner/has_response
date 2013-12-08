$:.push File.expand_path('../lib', __FILE__)
require 'has_response/version'

Gem::Specification.new do |s|
  s.name        = 'has_response'
  s.version     = HasResponse::VERSION
  s.authors     = ['Tom Benner']
  s.email       = ['tombenner@gmail.com']
  s.homepage    = 'https://github.com/tombenner/has_response'
  s.summary = s.description = 'Extremely simple API support for Rails models'

  s.files = Dir['lib/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'activesupport'
  s.add_dependency 'activerecord'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end
