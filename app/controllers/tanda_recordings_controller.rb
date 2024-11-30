class TandaRecordingsController < ApplicationController
  include ActionView::RecordIdentifier
  include Turbo::ForceTurboResponse

  force_turbo_response only: :index

  def index
    authorize tanda = Tanda.find(params[:tanda_id])

    recordings = if params[:query].present?
      Recording.search(
        params[:query],
        limit: 10,
        misspellings: {below: 10}
      )
    else
      tanda_recordings = tanda.tanda_recordings.includes(:recording)

      return [] if tanda_recordings.blank?

      TandaRecommendation.new(tanda).recommend_recordings
    end

    respond_to do |format|
      format.html do
        render partial: "results", locals: {recordings:, tanda:}
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "recording-results",
          partial: "results",
          locals: {recordings:, tanda:},
          method: :morph
        )
      end
    end
  end

  def create
    tanda = Tanda.find(params[:tanda_id])
    recording = Recording.find(params[:recording_id])
    authorize tanda_recording = tanda.tanda_recordings.create!(recording:)
    recordings = RecordingRecommendation.new(tanda).recommend_recordings

    respond_to do |format|
      format.turbo_stream do
        if recordings.any?
          render turbo_stream: [
            turbo_stream.append("tanda-recordings", partial: "tanda_recordings/tanda_recording", locals: {tanda_recording:}),
            turbo_stream.replace("recording-results", partial: "results", locals: {recordings:, tanda:})
          ]
        else
          render turbo_stream: turbo_stream.append("tanda-recordings", partial: "tanda_recordings/tanda_recording", locals: {tanda_recording:})
        end
      end
    end
  end

  def destroy
    authorize tanda_recording = TandaRecording.find(params[:id])
    tanda = tanda_recording.tanda
    recordings = RecordingRecommendation.new(tanda).recommend_recordings
    tanda_recording.destroy

    respond_to do |format|
      format.turbo_stream do
        if recordings.present?
          render turbo_stream: [
            turbo_stream.remove(dom_id(tanda_recording)),
            turbo_stream.replace("recording-results", partial: "results", locals: {recordings:, tanda:})
          ]
        else
          render turbo_stream: turbo_stream.remove(dom_id(tanda_recording))
        end
      end
    end
  end

  def reorder
    authorize tanda_recording = TandaRecording.find(params[:id])

    tanda_recording.update(position_position: params[:position], tanda_id: tanda_recording.tanda_id)

    head :ok
  end
end
