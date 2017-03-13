# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'tower_bridge_lifts/version'

Gem::Specification.new do |spec|
  spec.name          = "tower_bridge_lifts"
  spec.version       = TowerBridgeLifts::VERSION
  spec.authors       = ["Andre Parmeggiani"]
  spec.email         = ["aaparmeggiani@gmail.com"]

  spec.summary       = "Tower Bridge lift times"
  spec.description   = "Provides lift times information, parsed from TowerBridge.org.uk"
  spec.homepage      = "https://github.com/aaparmeggiani/tower_bridge_lifts"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"

  spec.add_dependency 'sinatra', '~> 1.4'
  spec.add_dependency 'tzinfo', '~> 1.2'
  spec.add_dependency 'nokogiri', '~> 1.6'

end

