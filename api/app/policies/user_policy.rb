# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def upload_avatar?
    end

    def delete_avatar?
    end

    def resolve
      scope.all
    end
  end
end
