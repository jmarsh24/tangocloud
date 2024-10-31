class QueuesController < ApplicationController
  include RemoteModal
  allowed_remote_modal_actions :show
  force_frame_response :show

  def show
    @queue = policy_scope(PlaybackQueue).find_or_create_by(user: current_user)

    authorize @queue

    if @queue.queue_items.empty?
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
end
