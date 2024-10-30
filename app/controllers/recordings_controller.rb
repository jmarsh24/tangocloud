class RecordingsController < ApplicationController
  def show
    @recording = policy_scope(Recording).with_associations.friendly.find(params[:id])
    authorize @recording
  end
end
