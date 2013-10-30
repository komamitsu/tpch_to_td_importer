# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tpch_to_td_importer/version'

Gem::Specification.new do |spec|
  spec.name          = "tpch_to_td_importer"
  spec.version       = TpchToTdImporter::VERSION
  spec.authors       = ["Mitsunori Komatsu"]
  spec.email         = ["komamitsu@gmail.com"]
  spec.description   = %q{Importer from TPC-H records to TreasureData}
  spec.summary       = %q{Importer from TPC-H records to TreasureData}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "td", ">= 0.10.91"
end
