class RecordingPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def play?
    admin?
  end

  def search?
    admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
