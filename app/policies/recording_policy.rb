class RecordingPolicy < ApplicationPolicy
  def show?
    user.admin? || user.tester? || user.editor?
  end

  def play?
    user.admin? || user.tester? || user.editor?
  end

  def search?
    user.admin? || user.tester? || user.editor?
  end

  def load?
    user.admin? || user.tester? || user.editor?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
