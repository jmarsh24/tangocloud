class ApplicationController < ActionController::Base
  include Authenticable
  include Pundit::Authorization

  after_action :verify_authorized, :verify_policy_scoped
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :set_playback_session_and_queue, :set_playlists
  before_action :set_user_library

  private

  def user_not_authorized(exception)
    flash[:alert] = I18n.t("pundit.not_authorized")
    redirect_back(fallback_location: sign_in_path)
  end

  def set_playback_session_and_queue
    if current_user
      @playback_session = PlaybackSession.find_or_create_by(user: current_user)
      @playback_queue = policy_scope(PlaybackQueue).find_or_create_by(user: current_user)
      @playback_queue.ensure_default_items
      @queue_items = @playback_queue.queue_items
                              .including_item_associations
                              .rank(:row_order)
                              .offset(1)
    end
  end

  def set_playlists
    @playlists = policy_scope(Playlist).with_attached_image.limit(64) if Current&.user
  end

  def set_user_library
    @user_library = policy_scope(UserLibrary).find_or_create_by!(user: Current.user) if Current&.user
  end
end