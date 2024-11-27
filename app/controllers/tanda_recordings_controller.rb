class TandaRecordingsController < ApplicationController
  include ActionView::RecordIdentifier

  def create
    @tanda = Tanda.find(params[:tanda_id])
    @recording = Recording.find(params[:recording_id])
    authorize @tanda_recording = @tanda.tanda_recordings.create!(recording: @recording)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.append("tanda-recordings", partial: "tanda_recordings/tanda_recording", locals: {tanda_recording: @tanda_recording})
        ]
      end
      format.html { redirect_to tanda_path(@tanda), notice: "Recording added to Tanda successfully." }
    end
  end

  def destroy
    authorize @tanda_recording = TandaRecording.find(params[:id])
    @tanda_recording.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(dom_id(@tanda_recording))
        ]
      end
      format.html { redirect_to tanda_path(@tanda_recording.tanda), notice: "Recording removed from Tanda successfully." }
    end
  end
end
