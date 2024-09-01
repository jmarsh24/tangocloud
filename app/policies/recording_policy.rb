class RecordingPolicy < ApplicationPolicy
  def search?
    admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
