require 'virtus'
require 'rest-client'

module RiakJson
  class Client
    include Virtus.model
  
    attribute :options, Hash
    
    def ping
      response = RestClient.get('http://localhost:8098/ping')
    end
  
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
end