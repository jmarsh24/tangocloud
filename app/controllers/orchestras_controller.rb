class OrchestrasController < ApplicationController
  def index
    @orchestras = policy_scope(Orchestra.ordered_by_recordings).limit(100).with_attached_image

    authorize Orchestra
  end

  def show
    @orchestra = policy_scope(Orchestra.includes(:genres, recordings: [:composition, digital_remasters: [album: [album_art_attachment: :blob]]])).friendly.find(params[:id])

    @years = @orchestra.recordings
      .where.not(recorded_date: nil)
      .pluck(Arel.sql("DISTINCT EXTRACT(YEAR FROM recorded_date)"))
      .map(&:to_i)
      .sort

    @genres = Genre
      .joins(:recordings)
      .where(recordings: {orchestra_id: @orchestra.id})
      .group("genres.id")
      .order(Arel.sql("CASE
      WHEN genres.name = 'Tango' THEN 1
      WHEN genres.name = 'Milonga' THEN 2
      WHEN genres.name = 'Vals' THEN 3
      WHEN genres.name = 'Condombe' THEN 4
      ELSE 5
    END, genres.name ASC"))

    @orchestra_periods = OrchestraPeriod
      .joins(:orchestra)
      .where(orchestra: {id: @orchestra.id})
      .group("orchestra_periods.id")
      .order("orchestra_periods.start_date ASC, orchestra_periods.end_date ASC")

    @singers = Person.with_attached_image
      .joins(:recording_singers)
      .where(recording_singers: {recording_id: @orchestra.recordings.select(:id)})
      .group("people.id")
      .select("people.*, COUNT(recording_singers.recording_id) AS recording_count")
      .order("recording_count DESC")

    # If filtering by year, only show recordings from the selected year
    @recordings = if params[:year].present?
      @orchestra.recordings
        .with_associations
        .where("EXTRACT(YEAR FROM recorded_date) = ?", params[:year])
    else
      @orchestra.recordings.with_associations
    end

    authorize @orchestra
  end
end
