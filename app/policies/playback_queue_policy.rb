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

  def add_to?
    record.user == user
  end

  def clear?
    record.user == user
  end

  def shuffle?
    record.user == user
  end

  def play_now?
    record.user == user
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
