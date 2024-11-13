class QueueItemPolicy < ApplicationPolicy
  def reorder?
    user == record.playback_queue.user
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end
