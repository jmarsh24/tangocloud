class TaggingPolicy < ApplicationPolicy
  def create?
    user.admin? || user.tester? || user.editor?
  end

  def destroy?
    record.user == user
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end
