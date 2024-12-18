class QueueItemsController < ApplicationController
  include ActionView::RecordIdentifier

  def destroy
    queue_item = @playback_queue.queue_items.find(params[:id])

    authorize queue_item

    dom_id = dom_id(queue_item)

    ActiveRecord::Base.transaction do
      if @playback_queue.current_item == queue_item
        @playback_queue.next_item
      end

      queue_item.delete
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(dom_id)
      end
    end
  end

  def reorder
    queue_item = @playback_queue.queue_items.find(params[:id])

    authorize queue_item

    queue_item.update!(
      row_order_position: params[:position],
      section: params[:section] || queue_item.section
    )

    head :ok
  end

  def play
    queue_item = @playback_queue.queue_items.find(params[:id])
    authorize queue_item
    @playback_queue.play_item!(queue_item)

    @playback_session.play(reset_position: true)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_session: @playback_session, playback_queue: @playback_queue}),
          turbo_stream.update("queue", partial: "queues/queue", locals: {playback_queue: @playback_queue, playback_session: @playback_session, queue_items: @playback_queue.queue_items.including_item_associations.rank(:row_order)})
        ]
      end
    end
  end

  def activate
    queue_item = @playback_queue.queue_items.now_playing.find(params[:id])
    authorize queue_item

    ActiveRecord::Base.transaction do
      @playback_queue.queue_items.now_playing.update_all(active: false)

      queue_item.update!(active: true)
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_session: @playback_session, playback_queue: @playback_queue}),
          turbo_stream.update("queue", partial: "queues/queue", locals: {playback_queue: @playback_queue, playback_session: @playback_session, queue_items: @playback_queue.queue_items.including_item_associations.rank(:row_order)})
        ]
      end
    end
  end
end
