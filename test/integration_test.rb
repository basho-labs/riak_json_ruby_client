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
  
  context "performs read/write/delete on a Document" do
    it "issues PUT requests to write a new document"
    it "issues POST requests to update an existing document"
    it "issues GET requests to read an existing document"
  end
  
  context "performs document Schema administration" do
    it "issues PUT requests to create a new schema"
    it "issues GET requests to read an existing schema from RiakJson/Solr"
    it "issues DELETE requests to remove a schema"
  end
  
  context "performs queries" do
    it "retrieves a single document with find_one()"
    it "retrieves many documents with find()"
  end
end
