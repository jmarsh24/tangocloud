module GraphQLHelper
  def gql(query, variables: {}, user: nil)
    context = {
      current_user: user
    }

    @result = ::TangocloudSchema.execute(query, variables:, context:)
  end

  def result(skip_errors: false)
    raise "GraphQL Error: #{gql_errors.map { |e| e["message"] }.join(", ")}" if gql_errors.any? && !skip_errors

    JSON.parse(@result.to_h.deep_transform_keys(&:underscore).to_json, object_class: OpenStruct)
  end

  def data
    result.data
  end

  def gql_errors
    @result["errors"] || []
  end

  def pp_gql
    pp @result
  end
end

RSpec.configure do |config|
  config.include GraphQLHelper, type: :graph
end
