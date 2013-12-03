require 'riak_json/version'
require 'riak_json/client'
require 'riak_json/collection'
require 'virtus'
require 'net/http'
require 'json'
require 'yaml'

module RiakJson
  class Document
    include Virtus

    attribute :key, String
    attribute :collection, Collection
    attribute :json, Hash
  end
end
