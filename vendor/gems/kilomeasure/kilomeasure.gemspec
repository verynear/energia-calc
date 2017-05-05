# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kilomeasure/version'

Gem::Specification.new do |spec|
  spec.name          = 'kilomeasure'
  spec.version       = Kilomeasure::VERSION
  spec.authors       = ['Wegonauts']
  spec.email         = ['developers@wegowise.com']
  spec.description   = 'Formulas for calculating potential building energy ' \
                       'efficiency.'
  spec.summary       = 'Collects numerous formulas that can be applied to ' \
                       'building characteristics to calculate potential ' \
                       'energy and cost savings.'
  spec.homepage      = 'http://wegowise.com'

  spec.files         = `git ls-files`.split($RS)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'dentaku', '~> 2.0.4', '>= 2.0'
  spec.add_dependency 'memoizer', '~> 1.0.1', '>= 1.0'
  spec.add_dependency 'activesupport', '~> 4.2.0', '>= 4.2'
  spec.add_dependency 'fattr', '~> 2.2', '>= 2.2.2'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0', '>= 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3.0', '>= 3.3'
  spec.add_development_dependency 'pry', '~> 0.10', '>= 0.10'
  spec.add_development_dependency 'pry-byebug', '~> 3.0', '>= 3.2'
  spec.add_development_dependency 'pry-stack_explorer', '~> 0.4', '>= 0.4.9'
  spec.add_development_dependency 'overcommit', '~> 0.26', '>= 0.26'
  spec.add_development_dependency 'json-schema', '~> 2.5.1'
end
