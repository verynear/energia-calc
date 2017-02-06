# -*- encoding: utf-8 -*-
require 'rubygems' unless defined? Gem
require File.dirname(__FILE__) + "/lib/door_stop/version"

Gem::Specification.new do |s|
  s.name        = "door_stop"
  s.version     = DoorStop::VERSION
  s.authors     = ["WegoWise Developers"]
  s.email       = "developers@wegowise.com"
  s.homepage    = "http://github.com/wegowise/door_stop"
  s.summary =  "a door stop for apps"
  s.description = "The ultimate protection from intruders, a door stop!"
  s.required_rubygems_version = ">= 1.3.6"
  s.add_dependency 'rack', '>= 1.2.0'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rspec', '~> 2.8.0'
  s.files = Dir.glob(%w[{lib,spec}/**/*.rb bin/* [A-Z]*.{txt,rdoc,md} ext/**/*.{rb,c}]) + %w{door_stop.gemspec}
  s.license = 'MIT'
end
