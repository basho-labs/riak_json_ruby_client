#require 'virtus'

module RiakJson
  class Document
#    include Virtus
#    attribute :key, String
#    attribute :collection, Collection
#    attribute :json, Hash
    
    attr_accessor :key
    
    def initialize(key=nil)
      @key = key
    end
    
  end
end