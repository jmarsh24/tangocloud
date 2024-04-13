class AudioVariantPolicy < ApplicationPolicy
  def show?
    user&.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
