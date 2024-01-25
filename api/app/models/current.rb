# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :user
  attribute :session
  attribute :user_agent
  attribute :ip_address

  def user
    return unless ActionAuth::Current.user
    ActionAuth::Current.user.becomes(User)
  end

  def session
    ActionAuth::Current.session
  end

  def user_agent
    ActionAuth::Current.user_agent
  end

  def ip_address
    ActionAuth::Current.ip_address
  end
end
