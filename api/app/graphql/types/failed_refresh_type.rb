module Types
  class FailedRefreshType < BaseObject
    field :error, String, null: false

    def error
      "Invalid refresh token"
    end
  end
end
