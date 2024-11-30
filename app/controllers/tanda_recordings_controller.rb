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
        misspellings: {below: 10},
        order: {_score: :desc}
      )
    elsif tanda.tanda_recordings.present?
      TandaRecommendation.new(tanda).recommend_recordings
    else
      Recording.none
    end

    orchestras = Orchestra.all.order(recordings_count: :desc)

    respond_to do |format|
      format.html do
        render partial: "results", locals: {recordings:, tanda:, orchestras:}
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "recording-results",
          partial: "results",
          locals: {recordings:, tanda:, orchestras:},
          method: :morph
        )
      end
    end
  end

  def create
    tanda = Tanda.find(params[:tanda_id])
    recording = Recording.find(params[:recording_id])
    authorize tanda.tanda_recordings.create!(recording:)
    recordings = TandaRecommendation.new(tanda).recommend_recordings
    tanda.update!(title: TandaTitleGenerator.generate(recordings))
    tanda.attach_default_image unless tanda.image.attached?

    redirect_to tanda_path(tanda)
  end

  def destroy
    authorize tanda_recording = TandaRecording.find(params[:id])
    tanda = tanda_recording.tanda
    recordings = TandaRecommendation.new(tanda).recommend_recordings
    tanda.update!(title: TandaTitleGenerator.generate(recordings))
    tanda_recording.destroy

    redirect_to tanda_path(tanda)
  end

  def reorder
    authorize tanda_recording = TandaRecording.find(params[:id])

    tanda_recording.update(position_position: params[:position], tanda_id: tanda_recording.tanda_id)

    head :ok
  end
end
