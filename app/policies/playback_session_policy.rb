class PlaybackQueuePolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  def next?
    record.user == user
  end

  def previous?
    record.user == user
  end

  def load_recording?
    record.user == user
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
