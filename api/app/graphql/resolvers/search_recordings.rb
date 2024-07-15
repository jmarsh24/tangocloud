# app/graphql/resolvers/search_recordings.rb
module Resolvers
  class SearchRecordings < BaseResolver
    type Types::RecordingSearchResultsType, null: false

    argument :filters, Types::RecordingFilterInputType, required: false
    argument :order_by, Types::RecordingOrderByInputType, required: false
    argument :query, String, required: false

    def resolve(query: "*", filters: nil, order_by: nil)
      search_options = {
        fields: ["title^2", "orchestra", "singers", "genre", "year"],
        match: :word_start,
        aggs: [:orchestra_periods, :time_period, :singers, :genre],
        misspellings: {below: 5}
      }

      search_options[:where].merge!(filters.to_h) if filters.present?

      search_options[:order] = {order_by.field => order_by.order} if order_by.present?

      search_result = ::Recording.search(query, **search_options)

      {
        recordings: search_result.results,
        aggregations: {
          orchestra_periods: format_aggregations(search_result.aggs["orchestra_periods"]["buckets"]),
          time_period: format_aggregations(search_result.aggs["time_period"]["buckets"]),
          genre: format_aggregations(search_result.aggs["genre"]["buckets"]),
          singers: format_aggregations(search_result.aggs["singers"]["buckets"])
        }
      }
    end

    private

    def format_aggregations(buckets)
      return [] unless buckets.present?

      buckets.map { |bucket| {key: bucket["key"], doc_count: bucket["doc_count"]} }
    end
  end
end
