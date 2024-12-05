class TandaRecordingsController < ApplicationController
  include ActionView::RecordIdentifier
  include Turbo::ForceTurboResponse

  force_turbo_response only: :index

  def index
    authorize tanda = Tanda.find(params[:tanda_id])

    where_clause = {}
    where_clause[:genre] = tanda.genre.name if tanda.genre.present?
    where_clause[:orchestra] = params[:orchestra] if params[:orchestra].present?
    where_clause[:singer] = params[:singer] if params[:singer].present?
    where_clause[:year] = params[:year].map(&:to_i) if params[:year].present?

    search_results = Recording.search(
      params[:query].presence || "*",
      where: where_clause,
      aggs: {
        orchestra: {where: where_clause},
        singer: {where: where_clause},
        year: {where: where_clause.except(:year)}
      },
      order: {_score: :desc},
      boost_by: {popularity_score: {factor: 2, modifier: "log1p"}},
      misspellings: {below: 10},
      smart_aggs: false,
      limit: 100,
      includes: [:composition, :orchestra, :singers, :genre, digital_remasters: [:audio_variants]]
    )

    orchestras = search_results.aggs.dig("orchestra", "buckets") || []
    singers = search_results.aggs.dig("singer", "buckets") || []
    years = (search_results.aggs.dig("year", "buckets") || []).sort_by { _1["key"] }

    recordings = search_results.results

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "recordings-and-filters",
          partial: "recordings_and_filters",
          locals: {
            tanda: tanda,
            query: params[:query],
            recordings: recordings,
            filters: where_clause,
            orchestras: orchestras,
            singers: singers,
            years: years
          },
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
    tanda.update!(title: TandaTitleGenerator.generate_from_recordings(recordings))
    tanda.attach_default_image unless tanda.image.attached?

    redirect_to tanda_path(tanda)
  end

  def destroy
    authorize tanda_recording = TandaRecording.find(params[:id])
    tanda = tanda_recording.tanda
    recordings = TandaRecommendation.new(tanda).recommend_recordings
    tanda.update!(title: TandaTitleGenerator.generate_from_recordings(recordings))
    tanda_recording.destroy

    redirect_to tanda_path(tanda)
  end

  def reorder
    authorize tanda_recording = TandaRecording.find(params[:id])

    tanda_recording.update(position_position: params[:position], tanda_id: tanda_recording.tanda_id)

    head :ok
  end
end
