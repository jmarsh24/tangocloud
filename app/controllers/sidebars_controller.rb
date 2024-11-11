class SidebarsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_queue, :set_playback_session
  skip_after_action :verify_authorized, only: [:show]
  skip_after_action :verify_policy_scoped, only: [:show]

  def show
    # Return nothing if no user is logged in
    return render plain: "", status: :ok unless Current.user

    authorize @playback_queue

    @playback_session = PlaybackSession.find_or_create_by(user: current_user)
    @playback_queue.ensure_default_items

    @playback_queue_items = @playback_queue.queue_items
      .including_item_associations
      .rank(:row_order)
      .offset(1)

    render partial: "show", locals: {playback_queue: @playback_queue, queue_items: @playback_queue_items, playback_session: @playback_session}
  end

  private

  def set_queue
    return unless Current.user

    @playback_queue = PlaybackQueue.find_or_create_by(user: current_user)
  end

  def set_playback_session
    return unless Current.user

    @playback_session = PlaybackSession.find_or_create_by(user: current_user)
  end
end