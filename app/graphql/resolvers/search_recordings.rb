module Resolvers
  class SearchRecordings < BaseResolver
    type Types::RecordingSearchResultsType, null: false

    argument :aggs, [Types::RecordingAggregationInputType], required: false
    argument :filters, Types::RecordingFilterInputType, required: false
    argument :limit, Integer, required: false, default_value: 20
    argument :offset, Integer, required: false, default_value: 0
    argument :order_by, Types::RecordingOrderByInputType, required: false
    argument :query, String, required: false

    def resolve(query: "*", filters: nil, order_by: nil, aggs: nil, limit: 20, offset: 0)
      search_options = {
        fields: ["title^2", "orchestra", "singers", "genre", "year"],
        match: :word_start,
        misspellings: {below: 5},
        limit:,
        offset:,
        where: {},
        aggs: {}
      }

      search_options[:where].merge!(filters.to_h) if filters.present?

      search_options[:order] = {order_by.field => order_by.order} if order_by.present?

      if aggs.present?
        search_options[:aggs] = aggs.map { _1.field.underscore.to_sym }
      end

      search_result = ::Recording.search(query, **search_options)

      result = {
        recordings: search_result.results,
        total_count: search_result.total_count
      }

      if aggs.present?
        result[:aggregations] = {}
        aggs.each do |agg|
          snake_case_agg = agg.field.underscore.to_sym

          result[:aggregations][snake_case_agg] = if search_result.aggs[snake_case_agg.to_s].present?
            format_aggregations(search_result.aggs[snake_case_agg.to_s]["buckets"])
          else
            []
          end
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
