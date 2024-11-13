class PlaylistPolicy < ApplicationPolicy
  def index?
    user.admin? || user.tester? || user.editor?
  end

  def show?
    user.admin? || user.tester? || user.editor?
  end

  def load?
    user.admin? || user.tester? || user.editor?
  end

  def add_to_library?
    user.admin? || user.tester? || user.editor?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end
