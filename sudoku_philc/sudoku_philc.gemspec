# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sudoku_philc/version'

Gem::Specification.new do |spec|
  spec.name          = "sudoku_philc"
  spec.version       = SudokuPhilc::VERSION
  spec.authors       = ["Phil Crissman"]
  spec.email         = ["phil.crissman@gmail.com"]
  spec.summary       = %q{Solve a sudoku from a CSV}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "debugger"
end
