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
    
    def get_raw_json(key)
      self.client.get_json_object(self.name, key)
    end
    
    def insert_raw_json(key, json_obj)
      self.client.insert_json_object(self.name, key, json_obj)
    end
    
#    def insert(document)
#      self.client.send_request(
#          :method => :post,
#          :path => "/collection/#{self.name}/#{document.key}",
#          :data => document.json
#      )
#    end
#
#    def find_by_key(key)
#      json_res = JSON.parse(self.client.send_request(
#                                :method => :get,
#                                :path => "/collection/#{self.name}/#{key}"
#                            ))
#
#      RiakJson::Document.new(
#          :key => key,
#          :json => json_res,
#          :collection => self
#      )
#    end
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
#
#    def create_schema(json)
#      self.client.send_request(
#          :method => :post,
#          :path => "/schemas/#{self.name}",
#          :data => json
#      )
#    end
#
#    def get_schema
#      JSON.parse(self.client.send_request(
#                     :method => :get,
#                     :path => "/schemas/#{self.name}"
#                 ))
#    end
  end
end