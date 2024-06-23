Searchkick.client = Elasticsearch::Client.new(
  url: ENV["ELASTICSEARCH_URL"] || "http://elasticsearch:9200",
  transport_options: {request: {timeout: 250}}
)
