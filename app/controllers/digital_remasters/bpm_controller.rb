class DigitalRemasters::BpmController < ApplicationController
  include RemoteModal

  before_action :set_digital_remaster

  def show
    respond_to do |format|
      format.html { render :show }
      format.turbo_stream
    end
  end

  def update
    if @digital_remaster.update(bpm_params)
      respond_to do |format|
        format.html { redirect_to @digital_remaster, notice: "BPM updated successfully." }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render :show, status: :unprocessable_entity }
        format.turbo_stream { render :show, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_digital_remaster
    @digital_remaster = digital_remaster.find(params[:digital_remaster_id])
  end

  def bpm_params
    params.require(:digital_remaster).permit(:bpm)
  end
end
