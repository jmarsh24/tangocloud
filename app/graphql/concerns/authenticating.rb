module Authenticating
  extend ActiveSupport::Concern

  included do
    def current_user
      context[:current_user]
    end
  end
end
