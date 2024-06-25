module Mutations
  module Users
    class Update < Mutations::BaseMutation
      argument :first_name, String, required: false
      argument :last_name, String, required: false
      argument :email, String, required: false
      argument :password, String, required: false
      argument :avatar, ApolloUploadServer::Upload, required: false

      field :user, Types::UserType, null: true
      field :errors, [String], null: true

      def resolve(email: nil, password: nil, first_name: nil, last_name: nil, avatar: nil)
        user = context[:current_user]
        user_preference = user.user_preference

        user_attributes = {
          email:,
          password:
        }

        user_preference_attributes = {
          first_name:,
          last_name:
        }

        if avatar.present?
          user_preference.avatar.attach(
            io: File.open(avatar),
            filename: avatar.original_filename,
            content_type: avatar.content_type
          )
        end

        if user.update(user_attributes) && user_preference.update(user_preference_attributes)
          {
            user:,
            errors: []
          }
        else
          {
            user: nil,
            errors: user.errors.full_messages + user_preference.errors.full_messages
          }
        end
      end
    end
  end
end
