class SessionPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    !user.nil?
  end

  def show?
    !user.nil?
  end

  def destroy?
    !user.nil? && record.user == user
  end

  class Scope < Scope
    def resolve
      scope.where(user:)
    end
  end
end
