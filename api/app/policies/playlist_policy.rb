class PlaylistPolicy < ApplicationPolicy
  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
