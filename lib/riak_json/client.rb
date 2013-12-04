require 'rest-client'

module RiakJson
  RIAK_TEST_HOST = '127.0.0.1'
  RIAK_TEST_PORT = 8098

  class ClientTransport
    def get_request(url)
      self.send_request(url, :get)
    end
    
    def send_request(url, http_method, data=nil)
      case http_method
        when :get
          response = RestClient.get(url)
        when :put
          response = RestClient.put url, data, { :content_type => 'application/json' }
        when :post
          response = RestClient.post url, data, { :content_type => 'application/json' }
        else
          raise ArgumentError, "Invalid HTTP :method - #{http_method}"
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
    
    def get_json_object(collection_name, key)
      self.transport.send_request("#{self.base_collection_url}/#{collection_name}/#{key}", :get)
    end
    
    def insert_json_object(collection_name, key, json)
      self.transport.send_request("#{self.base_collection_url}/#{collection_name}/#{key}", :put, json)
    end
    
    def ping
      response = self.transport.get_request("#{self.base_riak_url}/ping")
    end

    def update_json_object(collection_name, key, json)
      self.transport.send_request("#{self.base_collection_url}/#{collection_name}/#{key}", :post, json)
    end
    
#    def send_request(req_opts)
#      uri = URI.parse("#{self.options[:host]}#{req_opts[:path]}")
#      http = Net::HTTP.new(uri.host, uri.port)
#  
#      case req_opts[:method]
#        when :get
#          req = Net::HTTP::Get.new(uri.request_uri)
#        when :put
#          req = Net::HTTP::Put.new(uri.request_uri)
#          req.content_type = 'application/json'
#          req.body = req_opts[:data]
#        when :post
#          req = Net::HTTP::Post.new(uri.request_uri)
#          req["content_type"] = 'application/json'
#          req.body = req_opts[:data]
#        when :delete
#          req = Net::HTTP::Delete.new(uri.request_uri)
#        else
#          raise ArgumentError, 'Not a valid :method'
#      end
#  
#      res = http.request(req)
#      res.body
#    end
  end
end