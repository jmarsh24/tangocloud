module FieldDescribing
  extend ActiveSupport::Concern

  included do
    def preload(object, association)
      dataloader.with(Sources::Association, object.class, association).load(object)
    end

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

      def belongs_to(name, type: infer_type_from_association_name(name), null: false, association: name)
        id_field = :"#{name}_id"
        field(name, type, null:)
        field(id_field, Types::BaseObject::ID, null:)
        define_method name do
          dataloader.with(Sources::Association, object.class, association).load(object)
        end
      end

      alias_method :has_one, :belongs_to

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

      def enum_field(name, values: graphql_name.constantize.public_send(name.to_s.tableize).values, null: false)
        type = Class.new(Types::BaseEnum) do
          values.each do |e|
            value e, e.humanize
          end
        end
        const_set(graphql_name + name.to_s.classify, type)
        field(name, type, null:)
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
