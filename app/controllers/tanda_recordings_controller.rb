class TandaRecordingsController < ApplicationController
  include ActionView::RecordIdentifier
  include Turbo::ForceTurboResponse

  force_turbo_response only: :search

  def search
    authorize TandaRecording, :search?
    tanda = Tanda.find(params[:tanda_id])

    where_clause = {}
    where_clause[:genre] = tanda.genre.name if tanda.genre.present?
    where_clause[:orchestra] = params[:orchestra] if params[:orchestra].present?
    where_clause[:singer] = params[:singer] if params[:singer].present?
    where_clause[:soloist] = params[:soloist] if params[:soloist].present?
    where_clause[:year] = params[:year].map(&:to_i) if params[:year].present?

    facet_where_clause = params[:query].present? ? {} : where_clause
    search_results = Recording.search(
      params[:query].presence || "*",
      where: where_clause,
      aggs: {
        orchestra: {where: facet_where_clause},
        singer: {where: facet_where_clause},
        soloist: {where: facet_where_clause},
        year: {where: facet_where_clause.except(:year)}
      },
      order: {_score: :desc},
      boost_by: {popularity_score: {factor: 2, modifier: "log1p"}},
      misspellings: {below: 10},
      smart_aggs: false,
      limit: 100,
      includes: [:composition, :orchestra, :singers, :genre, digital_remasters: [:audio_variants, album: [album_art_attachment: :blob]]]
    )

    orchestras = search_results.aggs.dig("orchestra", "buckets") || []
    singers = search_results.aggs.dig("singer", "buckets") || []
    soloists = search_results.aggs.dig("soloist", "buckets") || []
    years = (search_results.aggs.dig("year", "buckets") || []).sort_by { _1["key"] }

    recording_results = search_results.results

    recordings = if recording_results.present?
      search_results.results.group_by(&:year)
    else
      []
    end

    suggested_orchestras = Orchestra.with_attached_image.order(recordings_count: :desc).limit(36) if recordings.blank?

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "recordings-and-filters",
          partial: "recordings_and_filters",
          locals: {
            tanda: tanda,
            recordings: recordings,
            filters: where_clause,
            orchestras: orchestras,
            singers: singers,
            soloists: soloists,
            years: years,
            suggested_orchestras:
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
    tanda.update!(title: TandaTitleGenerator.generate_from_recordings(tanda.recordings))
    tanda.attach_default_image unless tanda.image.attached?

    if tanda.tanda_recordings.size <= 5
      suggested_limit = [4 - tanda.tanda_recordings.size, 0].max
      if suggested_limit.positive?
        suggested_recordings = TandaRecommendation.new(tanda).recommend_recordings(limit: suggested_limit)
      end
    else
      suggested_recordings = []
    end

    tanda_recordings = tanda.tanda_recordings.includes(recording: [:composition, :orchestra, :singers, :genre, digital_remasters: [:audio_variants, album: [album_art_attachment: :blob]]])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            "tanda-title",
            partial: "tandas/title",
            locals: {title: tanda.title}
          ),
          turbo_stream.update(
            "tanda-recordings",
            partial: "tanda_recordings/tanda_recordings",
            locals: {tanda_recordings:, suggested_recordings:}
          ),
          turbo_stream.remove("recording-form-#{recording.id}") # Dynamically remove the form
        ]
      end
    end
  end

  def destroy
    authorize tanda_recording = TandaRecording.find(params[:id])
    tanda = tanda_recording.tanda
    tanda_recording.destroy
    tanda.update!(title: TandaTitleGenerator.generate_from_recordings(tanda.recordings))

    if tanda.tanda_recordings.size <= 5
      suggested_limit = [4 - tanda.tanda_recordings.size, 0].max
      if suggested_limit.positive?
        suggested_recordings = TandaRecommendation.new(tanda).recommend_recordings(limit: suggested_limit)
      end
    else
      suggested_recordings = []
    end

    tanda_recordings = tanda.tanda_recordings.includes(recording: [:composition, :orchestra, :singers, :genre, digital_remasters: [:audio_variants, album: [album_art_attachment: :blob]]])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            "tanda-title",
            partial: "tandas/title",
            locals: {title: tanda.title}
          ),
          turbo_stream.update(
            "tanda-recordings",
            partial: "tanda_recordings/tanda_recordings",
            locals: {tanda_recordings:, suggested_recordings:}
          )
        ]
      end
    end
  end

  def reorder
    authorize tanda_recording = TandaRecording.find(params[:id])

    tanda_recording.update(position_position: params[:position], tanda_id: tanda_recording.tanda_id)

    head :ok
  end
end
