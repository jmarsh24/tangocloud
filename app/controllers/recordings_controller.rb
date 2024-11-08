class RecordingsController < ApplicationController
  include Turbo::ForceFrameResponse
  force_frame_response :show
  
  def show
    authorize @recording = policy_scope(Recording).friendly.find(params[:id])
  end
end