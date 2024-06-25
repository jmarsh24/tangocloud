module Types
  class FailedLoginType < BaseObject
    field :error, String, null: false

    def error
      "Invalid login credentials"
    end
  end
end
