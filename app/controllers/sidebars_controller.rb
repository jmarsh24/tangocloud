class SidebarsController < ApplicationController
  before_action :set_queue
  skip_after_action :verify_authorized, only: [:show]

  def show
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
    @playback_queue = policy_scope(PlaybackQueue).find_or_create_by(user: current_user)
  end
end
