class ApplicationController < ActionController::Base
  include Authenticable
  include Pundit::Authorization
  include DetectDevice

  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :set_playback_context
  before_action :set_user_library

  private

  def user_not_authorized(exception)
    flash[:alert] = I18n.t("pundit.not_authorized")
    redirect_back(fallback_location: sign_in_path)
  end

  def set_playback_context
    if current_user
      @playback_session = PlaybackSession.find_or_create_by(user: current_user)
      @playback_queue = policy_scope(PlaybackQueue).find_or_create_by(user: current_user)
      @queue_items = @playback_queue.queue_items
        .including_item_associations
        .rank(:row_order)
    end
  end

  def set_user_library
    @user_library = policy_scope(UserLibrary).find_or_create_by!(user: Current.user) if Current&.user
    @library_items = @user_library&.library_items&.includes(item: {image_attachment: :blob})&.order(:row_order)&.all
  end
end
