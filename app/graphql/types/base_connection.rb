module Types
  class BaseConnection < Types::BaseObject
    include GraphQL::Types::Relay::ConnectionBehaviors

    edges_nullable(false)
    edge_nullable(false)
    node_nullable(false)
  end
end
