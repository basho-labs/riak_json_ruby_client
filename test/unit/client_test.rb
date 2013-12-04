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
end