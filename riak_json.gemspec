# coding: utf-8
## ------------------------------------------------------------------- 
## 
## Copyright (c) "2013" Basho Technologies, Inc.
##
## This file is provided to you under the Apache License,
## Version 2.0 (the "License"); you may not use this file
## except in compliance with the License.  You may obtain
## a copy of the License at
##
##   http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing,
## software distributed under the License is distributed on an
## "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
## KIND, either express or implied.  See the License for the
## specific language governing permissions and limitations
## under the License.
##
## -------------------------------------------------------------------
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'riak_json/version'

Gem::Specification.new do |spec|
  spec.name          = "riak_json"
  spec.version       = RiakJson::VERSION
  spec.authors       = ["Dmitri Zagidulin", "Drew Kerrigan"]
  spec.email         = ["dzagidulin@basho.com", "dkerrigan@basho.com"]
  spec.description   = %q{A Ruby client for Riak Json}
  spec.summary       = %q{riak_json is a client library for RiakJson, a set of JSON document based endpoints for the Riak database}
  spec.homepage      = "http://github.com/basho-labs/riak_json_ruby_client"
  spec.license       = "Apache 2.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'json'
  spec.add_dependency 'rest-client' 

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-spec-context"

  spec.add_development_dependency "ruby-prof"
  spec.add_development_dependency "debugger"
  spec.add_development_dependency "pry"
end
