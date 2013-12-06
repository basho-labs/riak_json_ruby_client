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

require 'rest-client'

module RiakJson
  RIAK_TEST_HOST = '127.0.0.1'
  RIAK_TEST_PORT = 8098

  class ClientTransport
    def get_request(url)
      self.send_request(url, :get)
    end
    
    def send_request(url, http_method, data=nil)
      begin
        case http_method
          when :get
            response = RestClient.get url
          when :put
            response = RestClient.put url, data, {:content_type => :json, :accept => :json}
          when :post
            response = RestClient.post url, data, {:content_type => :json, :accept => :json}
          when :delete
            response = RestClient.delete url
          else
            raise ArgumentError, "Invalid HTTP :method - #{http_method}"
        end
      end
      response
    end
  end
  
  class Client
    attr_accessor :collection_cache
    attr_accessor :transport
    attr_accessor :host, :port
    
    def initialize(host=RiakJson::RIAK_TEST_HOST, port=RiakJson::RIAK_TEST_PORT)
      @collection_cache = {}
      @transport = RiakJson::ClientTransport.new
      @host = host
      @port = port
    end
    
    def base_collection_url
      "#{self.base_riak_json_url}/collection"
    end
    
    def base_riak_url
      "http://#{self.host}:#{self.port}"
    end

    def base_riak_json_url
      "#{self.base_riak_url}/document"
    end
        
    def collection(name)
      self.collection_cache[name] ||= RiakJson::Collection.new(name, self)
    end

    def delete_json_object(collection_name, key)
      self.transport.send_request("#{self.base_collection_url}/#{collection_name}/#{key}", :delete)
    end

    def get_json_object(collection_name, key)
      self.transport.send_request("#{self.base_collection_url}/#{collection_name}/#{key}", :get)
    end
    
    def get_query_all(collection_name, query_json)
      self.transport.send_request("#{self.base_collection_url}/#{collection_name}/query/all", :put, query_json)
    end
    
    def get_query_one(collection_name, query_json)
      self.transport.send_request("#{self.base_collection_url}/#{collection_name}/query/one", :put, query_json)
    end
    
    def get_schema(collection_name)
      self.transport.send_request("#{self.base_collection_url}/#{collection_name}/schema", :get)
    end
    
    def insert_json_object(collection_name, key, json)
      self.transport.send_request("#{self.base_collection_url}/#{collection_name}/#{key}", :put, json)
    end
    
    def ping
      response = self.transport.get_request("#{self.base_riak_url}/ping")
    end

    def set_schema_json(collection_name, json)
      self.transport.send_request("#{self.base_collection_url}/#{collection_name}/schema", :put, json)
    end

    def update_json_object(collection_name, key, json)
      self.transport.send_request("#{self.base_collection_url}/#{collection_name}/#{key}", :put, json)
    end
  end
end