$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'scorched-helpers/version'

Gem::Specification.new 'scorched-helper', ScorchedHelpers::VERSION do |s|
  s.summary               = 'Helpers for the Scorched framework'
  s.description           = 'Helpers for the Scorched framework'
  s.authors               = ['K-2052']
  s.email                 = 'k@2052.me'
  s.homepage              = 'http://k2052.me'
  s.files                 = Dir.glob(`git ls-files`.split("\n") - %w[.gitignore])
  s.test_files            = Dir.glob('spec/**/*_spec.rb')
  s.rdoc_options          = %w[--line-numbers --inline-source --title Scorched --encoding=UTF-8]
  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'scorched', '~> 0.7'
  s.add_development_dependency 'rack-test', '~> 0.6'
  s.add_development_dependency 'rspec',     '~> 2.9'
end