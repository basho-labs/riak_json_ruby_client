# RiakJson Ruby Client Release Notes

## 0.0.4
Requires RiakJson >= v.0.0.3

* Adds support for [location](https://github.com/basho-labs/riak_json/issues/29) and 
[location_rpt](https://github.com/basho-labs/riak_json/issues/28) field types.
* [#3](https://github.com/basho-labs/riak_json_ruby_client/issues/3) Implement ```client.all()``` (List all docs for a 
collection (paginated))
* [#6](https://github.com/basho-labs/riak_json_ruby_client/issues/6) Implement ```collection.solr_query_raw(...)``` - perform
arbitrary Solr queries (used to test geospatial fields)

## 0.0.3
Requires RiakJson >= v.0.0.2 

* [#5](https://github.com/basho-labs/riak_json_ruby_client/issues/5) Implement ```client.collections()``` List Collections call

## 0.0.2
Initial implementation