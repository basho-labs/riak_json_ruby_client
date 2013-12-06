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

module RiakJson
  class Collection
    attr_accessor :name
    attr_accessor :client
    
    def initialize(collection_name, client)
      if collection_name.nil? or collection_name.empty?
        raise ArgumentError, "Invalid collection name (must not be nil or empty)"
      end
      @name = collection_name
      @client = client
    end
    
    def delete_raw_json(key)
      self.client.delete_json_object(self.name, key)
    end
    
    def find(query_json)
      json_obj = self.client.get_query_all(self.name, query_json)
      RiakJson::QueryResult.new(json_obj)
    end
    
    def find_by_key(key)
      json_obj = self.get_raw_json(key)
      body_hash = JSON.parse(json_obj)
      RiakJson::Document.new(key, body_hash)
    end
    
    def find_one(query_json)
      json_obj = self.client.get_query_one(self.name, query_json)
      body_hash = JSON.parse(json_obj)
      key = body_hash['_id']
      RiakJson::Document.new(key, body_hash)
    end
    
    def get_raw_json(key)
      self.client.get_json_object(self.name, key)
    end
    
    def get_schema
      self.client.get_schema(self.name)
    end
    
    def insert(document)
      self.insert_raw_json(document.key, document.to_json)
    end
    
    def insert_raw_json(key, json_obj)
      self.client.insert_json_object(self.name, key, json_obj)
    end
    
    def remove(document)
      self.delete_raw_json(document.key)
    end
    
    def set_schema(schema_json)
      self.client.set_schema_json(self.name, schema_json)
    end
    
    def update(document)
      self.update_raw_json(document.key, document.to_json)
    end
    
    def update_raw_json(key, json_obj)
      self.client.update_json_object(self.name, key, json_obj)
    end
#
#    def find(json)
#      json_res = JSON.parse(self.client.send_request(
#                                :method => :put,
#                                :path => "/query/all",
#                                :data => json
#                            ))
#
#      json_res.map { |json_doc|
#        RiakJson::Document.new(
#            :key => json_doc["key"],
#            :json => json_doc["data"],
#            :collection => self
#        )
#      }
#    end
#
#    def find_one(json)
#      json_res = JSON.parse(self.client.send_request(
#                                :method => :put,
#                                :path => "/query/one",
#                                :data => json
#                            ))
#
#      RiakJson::Document.new(
#          :key => json_res["key"],
#          :json => json_res["data"],
#          :collection => self
#      )
#    end

  end
end