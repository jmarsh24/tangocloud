module Mutations
  class Users::Update < Mutations::BaseMutation
    include Dry::Monads[:result]
    type Types::UserResultType, null: false

    argument :avatar, ApolloUploadServer::Upload, required: false
    argument :first_name, String, required: false
    argument :last_name, String, required: false
    argument :password, String, required: false

    def resolve(avatar: nil, password: nil, first_name: nil, last_name: nil)
      check_authentication!

      user = current_user

      if avatar
        user.user_preference.avatar.attach(
          io: avatar.tempfile.open,
          filename: avatar.original_filename,
          content_type: avatar.content_type
        )
      end
      user.password = password if password
      user.user_preference.first_name = first_name if first_name
      user.user_preference.last_name = last_name if last_name

      if user.save
        Success(user)
      else
        Failure(user)
      end
    end

    private

    def format_errors(errors)
      attribute_errors = errors.messages.map do |attribute, messages|
        {
          attribute: attribute.to_s.camelize(:lower),
          errors: messages
        }
      end

      {
        full_messages: errors.full_messages,
        attribute_errors:
      }
    end
  end
end
