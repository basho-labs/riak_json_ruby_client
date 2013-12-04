require 'rest-client'

module RiakJson
  RIAK_TEST_HOST = 'http://127.0.0.1'
  RIAK_TEST_PORT = 8098

  class ClientTransport
    def get_request(url)
      self.send_request(url, :get)
    end
    
    def send_request(relative_url, http_method, data=nil)
      url = RiakJson::Client::BASE_URL + relative_url
      case http_method
        when :get
          response = RestClient.get(url)
        when :put
          response = RestClient.put url, data, { :content_type => 'application/json' }
        else
          raise ArgumentError, "Invalid HTTP :method - #{http_method}"
      end
      response
    end
  end
  
  class Client
    BASE_URL = 'http://localhost:8098'
    
    attr_accessor :collection_cache
    attr_accessor :transport
    attr_accessor :host, :port
    
    def initialize(host=RiakJson::RIAK_TEST_HOST, port=RiakJson::RIAK_TEST_PORT)
      @collection_cache = {}
      @transport = RiakJson::ClientTransport.new
      @host = host
      @port = port
    end
    
    def collection(name)
      self.collection_cache[name] ||= RiakJson::Collection.new(name, self)
    end
    
    def get_json_object(collection_name, key)
      self.transport.send_request("/document/collection/#{collection_name}/#{key}", :get)
    end
    
    def insert_json_object(collection_name, key, json)
      self.transport.send_request("/document/collection/#{collection_name}/#{key}", :put, json)
    end
    
    def ping
      response = self.transport.get_request('/ping')
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