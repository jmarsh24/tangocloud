class LibraryItemPolicy < ApplicationPolicy
  def reorder?
    user == record.user_library.user
  end
  
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end