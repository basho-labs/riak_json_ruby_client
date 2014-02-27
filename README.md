# Riak Json Ruby Client

A Ruby client for [Riak Json](https://github.com/basho-labs/riak_json/).
For ActiveModel and Rails integration for RiakJson, see the [riagent](https://github.com/dmitrizagidulin/riagent) gem.

For a sample Rails 4 application using RiakJson, see [Riak Threaded Forum](https://github.com/dmitrizagidulin/riak-threaded-forum)

See also [RELEASE_NOTES.md](https://github.com/basho-labs/riak_json_ruby_client/blob/master/RELEASE_NOTES.md) for a version/feature log.

## Installation
To install from Ruby Gems:
```
gem install riak_json
```

To build locally, from source:
```bash
git clone git@github.com:basho/riak_json_ruby_client.git
cd riak_json_ruby_client
rake build
gem install pkg/riak_json-0.0.2.gem
```
## Unit Testing
Use bundler to install dev dependencies:
```
bundle install
```

To run just the unit tests (no db connection necessary):
```
bundle exec rake unittest
```

To run both unit and integration tests:

1. Make sure Riak with RiakJson is up and running. Note: By default, integration tests assume that Riak 
    is listening on ```127.0.0.1:8098``` (the result of ```make rel```).
    To specify alternate host and port, use the ```RIAK_HOST``` and ```RIAK_PORT``` env variables:
    ```
    RIAK_HOST=127.0.0.1 RIAK_PORT=10018 bundle exec rake
    ```
    
2. Seed the db (required for several of the integration tests)
    ```
    rake db:seed
    ```
    
3. Run the tests:
    ```
    bundle exec rake test
    ```

To run just the integration tests:
```
bundle exec rake itest
```

## Usage
### Loading the Client Config File
```ruby
require 'riak_json'

config_file = 'test/examples/riak.yml' # Loads in a config hash, by environment
dev_config = config_file['development']
client = RiakJson::Client.new(host=dev_config['host'], port=dev_config['http_port'])
```

### Creating / Referencing a Collection
```ruby
require 'riak_json'

client = RiakJson::Client.new('localhost', 8098)
# A new or existing collection
collection = client.collection("cities")
```

### Schema Administration
```ruby
# You may set an optional schema
# (or skip this step and go straight to inserting documents)
# Supported field types:
#   - string (no spaces, think of a url slug)
#   - text (spaces allowed)
#   - multi_string (an array of strings, no spaces)
#   - integer
#   - location (Solr 'location'/LatLonType type field)
#   - location_rpt (Solr 'location_rpt'/SpatialRecursivePrefixTreeFieldType type field)
schema = RiakJson::CollectionSchema.new
schema.add_text_field(name='city', required=true)
schema.add_string_field('state', true)
schema.add_multi_string_field('zip_codes') # required: false 
schema.add_integer_field('population', false)
schema.add_string_field('country', true)
schema.add_location_rpt_field('coordinates_rpt')

# Store the schema
collection.set_schema(schema)

# Check to see if schema is present
collection.has_schema?  # => true

# Read a stored schema for a collection
schema_result = collection.get_schema()
#   [{
#     :name => "city",
#     :type => "text",
#     :require => true
#    }, {
#      :name => "state",
#      :type => "string",
#      :require => true
#    }, {
#      :name => "zip_codes",
#      :type => "multi_string",
#      :require => false
#    }, {
#      :name => "population",
#      :type => "integer",
#      :require => false
#    }, {
#      :name => "coordinates_rpt",
#      :type => "location_rpt",
#      :require => false
#    }, {
#      :name => "country",
#      :type => "string",
#      :require => true
#    }]

# Delete the schema (and the index) for the collection
# WARNING: This deletes the index for the collection, so previously saved documents
#          will not show up in queries!
collection.delete_schema
```

### List All RiakJson Collections
This returns an array of ```RiakJson::Collection``` instances. 
Unlike the Riak 'List Buckets' call, this does not iterate through all of the keys, but gets the
custom RJ collection types from the ring metadata.

```ruby
client.collections()
```

### Reading and Writing Documents
```ruby
# You can insert a document with no key
# RiakJson generates a UUID type key and returns it
doc = RiakJson::Document.new
doc.body = { 'city'=>"Cleveland", 'state'=>'OH', 'country'=>'USA'}
doc.key  # => nil
collection.insert(doc)
doc.key  # => e.g. 'EmuVX4kFHxxvlUVJj5TmPGgGPjP'

# Populate the cities collection with data
doc = RiakJson::Document.new(
  key="nyc",
  body={ 'city'=>"New York", 'state'=>"NY", 'country'=>"USA" })
collection.insert(doc)
doc = RiakJson::Document.new(
  key="boston",
  body={ 'city'=>"Boston", 'state'=>"MA", 'country'=>"USA" })
collection.insert(doc)
doc = RiakJson::Document.new(
  key="sf",
  body={ 'city'=>"San Francisco", 'state'=>"CA", 'country'=>"USA" })
collection.insert(doc)

# Read a document (load by key)
doc = collection.find_by_key("nyc")
doc['city']  # => 'New York'

# Retrieve all documents for a collection (paginated)
collection.all(docs_per_page=100)
```

### Querying RiakJson - find_one() and find_all()
See [RiakJson Query Docs](https://github.com/basho-labs/riak_json/blob/master/docs/query.md) 
for a complete list of valid query parameters.
```ruby
# Exact match on "city" field
query = {"city" => "San Francisco"}.to_json
doc = collection.find_one(query)
# collection.find_one returns a Document instance
doc['city']  # => 'San Francisco'

# Find all documents that match the "country" field exactly
query = {"country" => "USA"}.to_json
results = collection.find_all(query)
results.documents.count  # => 3
results.num_pages  # => 1  -- total pages in result set
results.page  # => 0  -- current page (zero-indexed)
results.per_page  # results per page, defaults to 100
```
#### Limiting Query Results
```ruby
# Find all US cities, limit results to 10 per page
query = {'country'=>'USA', '$per_page'=>10}.to_json
results = collection.find_all(query)
results.per_page  #  => 10
```
#### Page Offsets
```ruby
# Find all US cities, retrieve 2nd page (zero-offset)
query = {'country'=>'USA', '$per_page'=>10, '$page'=>1}.to_json
results = collection.find_all(query)
results.page  #  => 1
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
