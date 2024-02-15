class AudioVariantPolicy < ApplicationPolicy
  attr_reader :user, :audio_variant

  def initialize(user, audio_variant)
    @user = user
    @audio_variant = audio_variant
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
