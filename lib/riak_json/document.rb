module RiakJson
  class Document
    attr_accessor :key
    attr_accessor :body
    
    def initialize(key=nil, body={})
      @key = key
      @body = body
    end
    
    def to_json
      self.body.to_json
    end
    
  end
end