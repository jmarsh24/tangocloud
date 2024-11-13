class QueueItemsController < ApplicationController
  def reorder
    queue_item = @playback_queue.queue_items.find(params[:id])
    queue_item.update(row_order_position: params[:position])
    head :ok
  end
end
