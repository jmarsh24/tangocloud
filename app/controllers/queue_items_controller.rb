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

    queue_item.update!(row_order_position: params[:position] + 1, playback_queue_id: @playback_queue.id)
    head :ok
  end
end
