class AudioPolicy < ApplicationPolicy
  attr_reader :user, :audio

  def initialize(user, audio)
    @user = user
    @audio = audio
  end

  def show?
    user&.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
