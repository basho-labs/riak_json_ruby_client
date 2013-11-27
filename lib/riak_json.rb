require "riak_json/version"
require 'virtus'
require 'net/http'
require 'json'
require 'yaml'

module RiakJson
  class Client
    include Virtus

    attribute :options, Hash

    def collection(name)
      @collection_cache ||= {}
      @collection_cache[name] ||= RiakJson::Collection.new(:client => self, :name => name)
    end

    def send_request(req_opts)
      uri = URI.parse("#{self.options[:host]}#{req_opts[:path]}")
      http = Net::HTTP.new(uri.host, uri.port)

      case req_opts[:method]
        when :get
          req = Net::HTTP::Get.new(uri.request_uri)
        when :put
          req = Net::HTTP::Put.new(uri.request_uri)
          req.content_type = 'application/json'
          req.body = req_opts[:data]
        when :post
          req = Net::HTTP::Post.new(uri.request_uri)
          req["content_type"] = 'application/json'
          req.body = req_opts[:data]
        when :delete
          req = Net::HTTP::Delete.new(uri.request_uri)
        else
          raise ArgumentError, 'Not a valid :method'
      end

      res = http.request(req)
      res.body
    end
  end

  class Collection
    include Virtus

    attribute :name, String
    attribute :client, RiakJson::Client

    def insert(document)
      self.client.send_request(
          :method => :post,
          :path => "/collection/#{self.name}/#{document.key}",
          :data => document.json
      )
    end

    def find_by_key(key)
      json_res = JSON.parse(self.client.send_request(
                                :method => :get,
                                :path => "/collection/#{self.name}/#{key}"
                            ))

      RiakJson::Document.new(
          :key => key,
          :json => json_res,
          :collection => self
      )
    end

    def find(json)
      json_res = JSON.parse(self.client.send_request(
                                :method => :put,
                                :path => "/query/all",
                                :data => json
                            ))

      json_res.map { |json_doc|
        RiakJson::Document.new(
            :key => json_doc["key"],
            :json => json_doc["data"],
            :collection => self
        )
      }
    end

    def find_one(json)
      json_res = JSON.parse(self.client.send_request(
                                :method => :put,
                                :path => "/query/one",
                                :data => json
                            ))

      RiakJson::Document.new(
          :key => json_res["key"],
          :json => json_res["data"],
          :collection => self
      )
    end

    def create_schema(json)
      self.client.send_request(
          :method => :post,
          :path => "/schemas/#{self.name}",
          :data => json
      )
    end

    def get_schema
      JSON.parse(self.client.send_request(
                     :method => :get,
                     :path => "/schemas/#{self.name}"
                 ))
    end
  end

  class Document
    include Virtus

    attribute :key, String
    attribute :collection, Collection
    attribute :json, Hash
  end
end
