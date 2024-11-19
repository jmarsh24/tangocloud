class Authentications::EventsController < ApplicationController
  include RemoteModal
  allowed_remote_modal_actions :index
  skip_after_action :verify_authorized

  def index
    @events = Current.user.events.order(created_at: :desc)
  end
end
