# Riak Json Ruby Client

A Ruby client for [Riak Json](https://github.com/basho-labs/riak_json/)

## Installation

Since this gem is not released to the public yet, build it locally:

```bash
git clone git@github.com:basho/riak_json_ruby_client.git
cd riak_json_ruby_client
gem build riak_json.gemspec
gem install riak_json-0.0.2.gem
```

## Usage

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
schema = RiakJson::CollectionSchema.new
schema.add_text_field(name='city', required=true)
schema.add_string_field('state', true)
schema.add_multi_string_field('zip_codes') # required: false 
schema.add_integer_field('population', false)
schema.add_string_field('country', true)

# Store the schema
collection.set_schema(schema)

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
#      :name => "country",
#      :type => "string",
#      :require => true
#    }]

# Delete (unset) a schema for a collection
collection.delete_schema
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
```

### Querying RiakJson - find_one() and find()
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
results = collection.find(query)
results.documents.count  # => 3
results.num_pages  # => 1  -- total pages in result set
results.page  # => 0  -- current page (zero-indexed)
results.per_page  # results per page, defaults to 100
```
#### Limiting Query Results
```ruby
# Find all US cities, limit results to 10 per page
query = {'country'=>'USA', '$per_page'=>10}.to_json
results = collection.find(query)
results.per_page  #  => 10
```
#### Page Offsets
```ruby
# Find all US cities, retrieve 2nd page (zero-offset)
query = {'country'=>'USA', '$per_page'=>10, '$page'=>1}.to_json
results = collection.find(query)
results.page  #  => 1
```

## Unit Testing
This runs both unit tests and integration tests.
Integration tests assume Riak is listening on ```127.0.0.1:8098```.
```
bundle install
bundle exec rake test
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
