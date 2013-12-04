require 'helper'

describe "RiakJson Ruby Client" do
  context "connects to RiakJson" do
    it "can perform an HTTP /ping to the RiakJson cluster" do
      client = RiakJson::Client.new
      response = client.ping
      response.must_equal 'OK'
      response.code.must_equal 200
    end
    
    it "raises an ArgumentError on send_request with invalid HTTP method"
  end
  
  context "performs document Schema administration" do
    it "issues PUT requests to create a new schema"
    it "issues GET requests to read an existing schema from RiakJson/Solr"
    it "issues DELETE requests to remove a schema"
  end
end
