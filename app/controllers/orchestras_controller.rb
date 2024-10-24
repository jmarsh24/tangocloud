class OrchestrasController < ApplicationController
  def index
    @orchestras = policy_scope(Orchestra.ordered_by_recordings).limit(100).with_attached_image

    authorize Orchestra
  end

  def show
    @orchestra = policy_scope(
      Orchestra.includes(
        :genres,
        recordings: [
          :composition,
          digital_remasters: [album: [album_art_attachment: :blob]]
        ]
      )
    ).friendly.find(params[:id])
    authorize @orchestra

    @filters = params.permit(:year, :genre, :orchestra_period, :singer).to_h

    @recordings = @orchestra.recordings.with_associations

    if @filters[:year].present?
      @recordings = @recordings.where("EXTRACT(YEAR FROM recorded_date) = ?", @filters[:year])
    end

    if @filters[:genre].present?
      @recordings = @recordings.joins(:genre).where(genre: {name: @filters[:genre]})
    end

    if @filters[:orchestra_period].present?
      period = @orchestra.orchestra_periods.find_by(name: @filters[:orchestra_period])
      if period.present?
        date_range = period.start_date..period.end_date
        @recordings = @recordings.where(recorded_date: date_range)
      else
        @recordings = @recordings.none
      end
    end

    if @filters[:singer].present?
      @recordings = @recordings
        .joins(recording_singers: :person)
        .where(people: {name: @filters[:singer]})
    end

    recording_ids = @recordings.select(:id)

    @years = @orchestra.recordings
      .where(id: recording_ids)
      .where.not(recorded_date: nil)
      .distinct
      .pluck(Arel.sql("EXTRACT(YEAR FROM recorded_date)"))
      .map(&:to_i)
      .sort

    @genres = Genre
      .joins(:recordings)
      .where(recordings: {id: recording_ids})
      .group("genres.id")
      .order(Arel.sql("CASE
                  WHEN genres.name = 'Tango' THEN 1
                  WHEN genres.name = 'Milonga' THEN 2
                  WHEN genres.name = 'Vals' THEN 3
                  WHEN genres.name = 'Condombe' THEN 4
                  ELSE 5
                END, genres.name ASC"))

    @orchestra_periods = OrchestraPeriod
      .joins(orchestra: :recordings)
      .where(recordings: {id: recording_ids})
      .group("orchestra_periods.id")
      .order("orchestra_periods.start_date ASC, orchestra_periods.end_date ASC")

    @singers = Person.with_attached_image
      .joins(:recording_singers)
      .where(recording_singers: {recording_id: recording_ids})
      .group("people.id")
      .select("people.*, COUNT(recording_singers.recording_id) AS recording_count")
      .order("recording_count DESC")

    @recordings = @recordings.limit(100)
  end
end
