require 'helper'

describe "a RiakJson Client" do
  context "when created" do
    it "has an empty collection cache" do
      client = test_client
      client.collection_cache.must_be_empty
    end
  end

  it "uses its collection cache when instantiating collections" do
    client = test_client
    collection1 = client.collection('test_collection')
    collection2 = client.collection('test_collection')
    collection1.must_be_same_as collection2, "Client uses collection cache, collection1 and collection2 should be identical"
  end
  
  it "writes JSON objects to collections" do
    client = test_client
    collection_name = 'test_collection'
    test_key = 'document-key-123'
    test_json = { :key => test_key, :field_one => '123', :field_two => 'abc' }.to_json
    client.transport = MiniTest::Mock.new
    
    # Test that a client.insert_json_object call results in an HTTP PUT request to /collection_name/key
    client.transport.expect :send_request, nil, ['/test_collection/document-key-123', :put, test_json]
    client.insert_json_object(collection_name, test_key, test_json)
    client.transport.verify
  end
end