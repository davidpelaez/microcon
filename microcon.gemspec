# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'microcon/version'

Gem::Specification.new do |spec|
  spec.name          = "microcon"
  spec.version       = Microcon::VERSION
  spec.authors       = ["David Peláez"]
  spec.email         = ["pelaez89@gmail.com"]
  spec.summary       = "Small controller for JSON APIs"
  spec.description   = "Most JSON APIs have a limited number of respondes or outcomes. Microcon tries to separate HTTP related concerns from business logic and removes most of the mental clutter regarding JSON parsing, rendering and consistent API responses."
  spec.homepage      = "https://github.com/davidpelaez/microcon"
  spec.license       = "MIT"

  spec.files         = `git ls-files lib -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "dry-monads", "~> 0.0.2"
  spec.add_runtime_dependency "dry-container", "~> 0.3.4"
  spec.add_runtime_dependency "adts", "~> 0.1.2"
  spec.add_runtime_dependency 'rack', '~> 2.0', '>= 2.0.1'
  spec.add_runtime_dependency 'oj', '~> 2.17', '>= 2.17.1'
  spec.add_runtime_dependency "transproc", "~> 0.4.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 11.0"
end
