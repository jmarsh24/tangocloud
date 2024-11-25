class QueueItemsController < ApplicationController
  def reorder
    queue_item = @playback_queue.queue_items.find(params[:id])

    authorize queue_item

    queue_item.update!(row_order_position: params[:position] + 1, playback_queue_id: @playback_queue.id)
    head :ok
  end
end
