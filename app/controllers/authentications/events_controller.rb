class Authentications::EventsController < ApplicationController
  include RemoteModal
  respond_with_remote_modal only: [:index]
  skip_after_action :verify_authorized

  def index
    @events = Current.user.events.order(created_at: :desc)
  end
end
