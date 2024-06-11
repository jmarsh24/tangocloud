require "search_object"
require "search_object/plugin/graphql"

module Resolvers
  class BaseSearchResolver < GraphQL::Schema::Resolver
    include ::SearchObject.module(:graphql)

    scope { [] }

    FILTER_BY_DATE_INPUT = begin
      Class.new(Types::BaseInputObject) do
        graphql_name "FilterByDateInput"

        argument :from, GraphQL::Types::ISO8601DateTime, required: true
        argument :to, GraphQL::Types::ISO8601DateTime, required: true
      end
    end

    ORDER_BY_DIRECTION_INPUT = begin
      Class.new(Types::BaseEnum) do
        graphql_name "OrderByDirection"

        %w(desc asc).map { |e|
          value e.upcase, value: e
        }
      end
    end

    def self.create_connection_for(klass)
      plural = ActiveSupport::Inflector.pluralize(klass.to_s)

      edge = Class.new(GraphQL::Types::Relay::BaseEdge) do
        graphql_name "#{plural}EdgeType"
        node_type("Types::#{klass}Type".constantize)
      end

      connection =  Class.new(GraphQL::Types::Relay::BaseConnection) do
        graphql_name "#{plural}Connection"

        field :total_count, Integer, null: false
        def total_count
          object.nodes.size
        end
        edge_type(edge)
      end

      type connection, null: false
    end

    def self.add_search_for(klass, search_options = {})
      option(:search, type: String) do |scope, value|
        if value.present?
          search_params = { load: false, select: [:id] }.merge(search_options)
          ids = klass.search(value, **search_params).map(&:id)
          scope.where(id: ids)
        end
      end
    end

    def self.add_order_by_for(klass)
      input = create_order_by_input(klass)

      option(:order_by, type: input) { |scope, value|
        if value
          value = value.to_h
          scope.order("#{value[:field]} #{value[:direction]}")
        end
      }
    end

    def self.add_filter_by_datetime_for(klass)
      klass.datetime_attributes.map do |attribute|
        option("filter_by_#{attribute}".to_sym, type: FILTER_BY_DATE_INPUT) { |scope, value|
          if value
            value = value.to_h
            scope.where(attribute => value[:from]..value[:to])
          end
        }
      end
    end

    private

    def self.create_order_by_input(klass)

      fields = Class.new(Types::BaseEnum) do
        graphql_name "#{klass}OrderByField"

        klass.attribute_names.map { |e|
          value e.upcase, value: e
        }
      end

      input = Class.new(Types::BaseInputObject) do
        argument :field, fields, required: true
        argument :direction, ORDER_BY_DIRECTION_INPUT, required: true

        graphql_name "#{klass}OrderByInput"

      end

      input
    end

  end
end
