module Orchestras
  class RecordingsController < ApplicationController
    def index
      @orchestra = Orchestra.friendly.find(params[:orchestra_id])

      @recordings = filter_recordings(@orchestra.recordings)

      @years = fetch_years(@recordings)
      @genres = fetch_genres(@recordings)
      @singers = fetch_singers(@recordings)
    end

    private

    def filter_recordings(recordings)
      recordings = recordings.where("EXTRACT(YEAR FROM recorded_date) = ?", params[:year]) if params[:year].present?
      recordings = recordings.joins(:genre).where(genres: {name: params[:genre]}) if params[:genre].present?
      recordings = recordings.joins(:singers).where(people: {name: params[:singer]}) if params[:singer].present?

      case params[:sort]
      when "popularity"
        recordings.order(playbacks_count: :desc)
      when "date"
        recordings.order(recorded_date: :desc)
      else
        # recordings.order(composition: :title)
      end
    end

    def fetch_years(recordings)
      recordings.where.not(recorded_date: nil).pluck(Arel.sql("DISTINCT CAST(EXTRACT(YEAR FROM recorded_date) AS INTEGER)")).sort
    end

    def fetch_genres(recordings)
      Genre.joins(:recordings).where(recordings: {id: recordings.select(:id)}).group("genres.id")
    end

    def fetch_singers(recordings)
      Person.with_attached_image
        .joins(:recording_singers)
        .where(recording_singers: {recording_id: recordings.select(:id)})
        .group("people.id")
        .select("people.*, COUNT(recording_singers.recording_id) AS recording_count")
        .order("recording_count DESC")
    end
  end
end
