class QueueItemPolicy < ApplicationPolicy
  def destroy?
    user == record.playback_queue.user
  end

  def reorder?
    user == record.playback_queue.user
  end

  def play?
    user == record.playback_queue.user
  end

  def activate?
    user == record.playback_queue.user
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end
