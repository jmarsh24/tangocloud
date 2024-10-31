class PlaybackQueuePolicy < ApplicationPolicy
  def show?
    user.admin? || user.tester? || user.editor?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
