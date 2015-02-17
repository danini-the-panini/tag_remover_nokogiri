# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tag_remover/version'

Gem::Specification.new do |spec|
  spec.name          = "tag_remover_nokogiri"
  spec.version       = TagRemover::VERSION
  spec.authors       = ["Daniel Smith"]
  spec.email         = ["jellymann@gmail.com"]
  spec.summary       = %q{Remove elements from large XML documents (using nokogiri).}
  spec.description   = %q{Tag remover let's you remove all elements of specified tags from extremely large XML documents without parsing or loading the whole thing in memory, useful for processing unreasonably large documents without making your server fall over.}
  spec.homepage      = "https://github.com/jellymann/tag_remover_nokogiri"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.2"

  spec.add_runtime_dependency "nokogiri", "~> 1.6"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
end
