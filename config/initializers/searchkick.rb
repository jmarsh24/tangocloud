Searchkick.client = Elasticsearch::Client.new(
  url: Rails.application.credentials.dig(:elasticsearch_url) || "http://127.0.0.1:9200",
  transport_options: {request: {timeout: 250}}
)
