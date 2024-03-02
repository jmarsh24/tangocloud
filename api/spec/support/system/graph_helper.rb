# frozen_string_literal: true

module GraphQLHelper
  def gql(query, variables: {})
    context = {
      current_user:
    }
    @result = TangoCloudSchema.execute(query, variables:, context:)
  end

  def result(skip_errors: false)
    result = @result
    unless skip_errors
      raise "GraphQL Error: #{result["errors"].to_json}" if result["errors"]
    end
    JSON.parse(result.to_h.deep_transform_keys(&:underscore).to_json, object_class: OpenStruct)
  end

  def gql_errors
    result(skip_errors: true).errors || []
  end

  delegate :data, to: :result

  def pgql
    puts JSON.pretty_generate(@result.as_json)
  end
end

RSpec.configure do |config|
  config.include GraphQLHelper, type: :graph
  config.include GraphQLHelper, type: :system
end
