class PlaybackSessionPolicy < ApplicationPolicy
  def play?
    record.user == user
  end

  def pause?
    record.user == user
  end

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

  def update_volume?
    record.user == user
  end

  def mute?
    record.user == user
  end

  def unmute?
    record.user == user
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
