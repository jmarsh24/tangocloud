class TandaRecordingsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_tanda_recording, only: [:destroy, :reorder]

  def create
    @tanda = Tanda.find(params[:tanda_id])
    @recording = Recording.find(params[:recording_id])
    authorize @tanda_recording = @tanda.tanda_recordings.create!(recording: @recording)
    @recommended_recordings = RecordingRecommendation.new(@tanda.recordings.order(position: :asc)).recommend_recordings

    respond_to do |format|
      format.turbo_stream do
        if @recommended_recordings.any?
          render turbo_stream: [
            turbo_stream.append("tanda-recordings", partial: "tanda_recordings/tanda_recording", locals: {tanda_recording: @tanda_recording}),
            turbo_stream.replace("recording-suggestions", partial: "recordings/results", locals: {recordings: @recommended_recordings, tanda: @tanda})
          ]
        else
          render turbo_stream: turbo_stream.append("tanda-recordings", partial: "tanda_recordings/tanda_recording", locals: {tanda_recording: @tanda_recording})
        end
      end
      format.html { redirect_to tanda_path(@tanda), notice: "Recording added to Tanda successfully." }
    end
  end

  def destroy
    tanda = @tanda_recording.tanda
    @recommended_recordings = RecordingRecommendation.new(tanda.recordings.order(position: :asc)).recommend_recordings
    @tanda_recording.destroy

    respond_to do |format|
      format.turbo_stream do
        if @recommended_recordings.any?
          render turbo_stream: [
            turbo_stream.remove(dom_id(@tanda_recording)),
            turbo_stream.replace("recording-suggestions", partial: "recordings/results", locals: {recordings: @recommended_recordings, tanda:})
          ]
        else
          render turbo_stream: turbo_stream.remove(dom_id(@tanda_recording))
        end
      end
      format.html { redirect_to tanda_path(@tanda_recording.tanda), notice: "Recording removed from Tanda successfully." }
    end
  end

  def reorder
    @tanda_recording.update(position_position: params[:position], tanda_id: @tanda_recording.tanda_id)

    head :ok
  end

  private

  def set_tanda_recording
    authorize @tanda_recording = TandaRecording.find(params[:id])
  end
end
