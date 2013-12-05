#require 'virtus'

module RiakJson
  class Document
#    include Virtus
#    attribute :key, String
#    attribute :collection, Collection
#    attribute :json, Hash
    
    attr_accessor :key
    attr_accessor :body
    
    def initialize(key=nil, body=nil)
      @key = key
      @body = body
    end
    
  end
end