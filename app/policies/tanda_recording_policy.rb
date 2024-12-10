class TandaRecordingPolicy < ApplicationPolicy
  def search?
    user.admin? || user.tester? || user.editor?
  end

  def create?
    user.admin? || user.tester? || user.editor?
  end

  def destroy?
    record.tanda&.user == user && (user.admin? || user.tester? || user.editor?)
  end

  def reorder?
    record.tanda&.user == user && (user.admin? || user.tester? || user.editor?)
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end
