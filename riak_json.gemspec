# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'riak_json/version'

Gem::Specification.new do |spec|
  spec.name          = "riak_json"
  spec.version       = RiakJson::VERSION
  spec.authors       = ["Drew Kerrigan"]
  spec.email         = ["dkerrigan@basho.com"]
  spec.description   = %q{A Ruby client for Riak Json}
  spec.summary       = %q{riak_json is a client library for RiakJson, a set of JSON document based endpoints for the Riak database}
  spec.homepage      = "http://github.com/basho/riak_json_ruby_client"
  spec.license       = "Apache 2.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'json', '~> 1.7.7'
  spec.add_development_dependency 'virtus'
end
