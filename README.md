# Riak Json Ruby Client

A Ruby client for [Riak Json](https://github.com/basho-labs/riak_json/)

## Installation

Since this gem is not released to the public yet, build it locally:

    git clone git@github.com:basho/riak_json_ruby_client.git
    cd riak_json_ruby_client && gem build riak_json
    gem install riak_json-0.0.2.gem

## Usage
```ruby
    require 'riak_json'

    client = RiakJson::Client.new('localhost', 8098)
    collection = client.collection("cities")

    schema = [{
        :name => "city",
        :type => "text",
        :require => true
    }, {
        :name => "state",
        :type => "string",
        :require => true
    }, {
        :name => "country",
        :type => "string",
        :require => true
    }].to_json

    collection.set_schema(schema)

    key = "nyc"
    body = { "city" => "New York", "state" => "NY", "country" => "USA" }
    document = RiakJson::Document.new(key, body)

    collection.insert(document)

    all_results = collection.find({"country" => "USA"}.to_json)  # find all documents that match this field

    one_result = collection.find_one({"city" => "New York"}.to_json)  # exact match on "city" field

    key_result = collection.find_by_key("nyc")

    schema_result = collection.get_schema()
```

## Testing
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
