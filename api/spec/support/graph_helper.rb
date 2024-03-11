module GraphQLHelper
  def gql(query, variables: {}, user: nil)
    context = {
      current_user: user
    }

    @result = ::TangocloudSchema.execute(query, variables:, context:)
  end

  def result(skip_errors: false)
    result = @result
    unless skip_errors
      raise "GraphQL Error: #{result["errors"].to_json}" if result["errors"]
    end
    JSON.parse(result.to_h.deep_transform_keys(&:underscore).to_json, object_class: OpenStruct)
  end

  delegate :data, to: :result

  def gql_errors
    result(skip_errors: true).errors || []
  end

  def pp_gql
    pp @result
  end
end

RSpec.configure do |config|
  config.include GraphQLHelper, type: :graph
end
