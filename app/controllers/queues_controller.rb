class QueuesController < ApplicationController
  def show
    @queue = PlaybackQueue.new(user: current_user)

    authorize @queue

    recordings = policy_scope(Recording).limit(10)
    tandas = policy_scope(Tanda).limit(10)

    recordings.each do |recording|
      @queue.queue_items.build(item: recording)
    end

    tandas.each do |tanda|
      @queue.queue_items.build(item: tanda)
    end

    @queue.save!
  end
end
