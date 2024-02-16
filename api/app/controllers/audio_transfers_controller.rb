class AudioTransfersController < ApplicationController
  def new
    authorize AudioTransfer.new
  end
end
