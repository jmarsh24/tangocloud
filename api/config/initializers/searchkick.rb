Searchkick.client = Elasticsearch::Client.new(
  url: Config.elasticsearch_url || "http://elasticsearch:9200",
  transport_options: {request: {timeout: 250}}
)
