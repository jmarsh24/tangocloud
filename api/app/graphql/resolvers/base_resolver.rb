module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    include Authenticating
  end
end
