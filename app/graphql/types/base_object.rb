module Types
  class BaseObject < GraphQL::Schema::Object
    include Authenticating

    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
    field_class Types::BaseField

    class << self
      def has_many(name, scope = nil, association: name, type: infer_type_from_association_name(association), id_accessor: true, after_load: nil)
        field name, type.connection_type, null: false
        define_method name do
          records = dataloader.with(Sources::Association, object.class, association, scope && object.class.reflect_on_association(association).klass.instance_exec(&scope)).load(object)
          after_load&.call(records)
          records
        end
        return unless id_accessor

        single_name = name.to_s.singularize
        field single_name, type, null: false do
          argument :id, Types::BaseObject::ID, required: true
        end
        define_method single_name do |id:|
          object.public_send(association).find(id)
        end
      end

      def has_one_attached(name)
        field name, Types::AttachmentType, null: true

        define_method name do
          dataloader
            .with(GraphQL::Sources::ActiveStorageHasOneAttached, name)
            .load(object)
        end
      end

      def has_many_attached(name)
        field name, [Types::AttachmentType], null: true

        define_method name do
          dataloader
            .with(GraphQL::Sources::ActiveStorageHasManyAttached, name)
            .load(object)
        end
      end

      def enum_field(name, values:, null: false)
        type = Class.new(BaseEnum) do
          values.each do |e|
            value e.upcase, value: e
          end
        end
        const_set(graphql_name + name.to_s.classify, type)
        field name, type, null:
      end

      def infer_type_from_association_name(name)
        class_name = name.to_s.singularize.classify
        klass = "Types::#{class_name}Type".safe_constantize
        raise ArgumentError, "cannot infer type for association '#{name}'. Specify a type (2nd parameter) when declaring the field." unless klass

        klass
      end

      def infer_model_from_association_name(name)
        name.to_s.singularize.classify.constantize
      end
    end
  end
end
