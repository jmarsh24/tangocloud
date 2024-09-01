module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    include Authenticating
    include Authorizing
  end
end
