Searchkick.client = Elasticsearch::Client.new(
  url: ENV["ELASTICSEARCH_URL"] || "http://127.0.0.1:9200",
  transport_options: {request: {timeout: 250}}
)
