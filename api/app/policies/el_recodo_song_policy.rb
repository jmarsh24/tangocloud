class ElRecodoSongPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def edit?
    false
  end

  def show?
    user.admin?
  end

  def create?
    false
  end

  def new?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end

  def act_on?
    user.admin?
  end

  def search?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
