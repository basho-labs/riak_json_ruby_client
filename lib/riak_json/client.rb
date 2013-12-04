require 'rest-client'

module RiakJson
  class ClientTransport
    def send_request(relative_url, method, data)
    end
  end
  
  class Client
    BASE_URL = 'http://localhost:8098'
    
    attr_accessor :collection_cache
    attr_accessor :transport
    
    def initialize
      @collection_cache = {}
      @transport = RiakJson::ClientTransport.new
    end
    
    def collection(name)
      self.collection_cache[name] ||= RiakJson::Collection.new(name, self)
    end
    
    def ping
      response = self.get_request('/ping')
    end
  
    def get_request(url)
      self.send_request({
        :url => url,
        :method => :get})
    end
    
    def insert_json_object(collection_name, key, json)
      self.transport.send_request("/#{collection_name}/#{key}", :put, json)
    end
    
    def send_request(request_options={})
      url = RiakJson::Client::BASE_URL + request_options[:url]
      http_method = request_options[:method]
      case http_method
        when :get
          response = RestClient.get(url)
        else
          raise ArgumentError, "Invalid HTTP :method - #{http_method}"
      end
      response
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