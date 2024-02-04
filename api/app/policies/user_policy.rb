class UserPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.admin?
  end

  def show?
    true
  end

  def create?
    true
  end

  def new?
    true
  end

  def edit?
    user == record
  end

  def update?
    user == record
  end

  def destroy?
    user == record || user.admin?
  end

  def upload_avatar?
  end

  def delete_avatar?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
