module Resolvers
  class SearchRecordings < BaseResolver
    type Types::RecordingSearchResultsType, null: false

    argument :filters, Types::RecordingFilterInputType, required: false
    argument :order_by, Types::RecordingOrderByInputType, required: false
    argument :query, String, required: false
    argument :aggs, [String], required: false
    argument :limit, Integer, required: false, default_value: 20
    argument :offset, Integer, required: false, default_value: 0

    def resolve(query: "*", filters: nil, order_by: nil, aggs: nil, limit: 20, offset: 0)
      authorize(::Recording, :search?)

      search_options = {
        fields: ["title^2", "orchestra", "singers", "genre", "year"],
        match: :word_start,
        misspellings: {below: 5},
        limit:,
        offset:
      }

      search_options[:where].merge!(filters.to_h) if filters.present?

      search_options[:order] = {order_by.field => order_by.order} if order_by.present?

      if aggs.present?
        search_options[:aggs] = aggs.map(&:to_sym)
      end

      search_result = ::Recording.search(query, **search_options)

      result = {
        recordings: search_result.results,
        total_count: search_result.total_count
      }

      if aggs.present?
        result[:aggregations] = {}
        aggs.each do |agg|
          result[:aggregations][agg.to_sym] = format_aggregations(search_result.aggs[agg]["buckets"])
        end
      end

      result
    end

    private

    def format_aggregations(buckets)
      return [] unless buckets.present?

      buckets.map { |bucket| {key: bucket["key"], doc_count: bucket["doc_count"]} }
    end
  end
end
