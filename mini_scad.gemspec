# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mini_scad/version"

Gem::Specification.new do |spec|
  spec.name          = "mini_scad"
  spec.version       = MiniScad::VERSION
  spec.authors       = ["daisuko"]
  spec.email         = ["striker.daisuko@gmail.com"]

  spec.summary       = %q(MiniScad is a bridge to the OpenSCAD script.)
  spec.description   = %q(MiniScad is a bridge to the OpenSCAD script.)
  spec.homepage      = "https://github.com/daisuko/mini_scad"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
end
