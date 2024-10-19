class OrchestrasController < ApplicationController
  def index
    @orchestras = policy_scope(Orchestra.ordered_by_recordings).limit(100).with_attached_image

    authorize Orchestra
  end

  def show
    @orchestra = policy_scope(Orchestra.includes(:genres, recordings: [:composition, digital_remasters: [album: [album_art_attachment: :blob]]])).friendly.find(params[:id])
    @genres = Genre.joins(:recordings).where(recordings: {orchestra_id: @orchestra.id}).distinct
    @orchestra_periods = OrchestraPeriod.joins(:orchestra).where(orchestra: {id: @orchestra.id}).distinct
    @singers = Person.with_attached_image
      .joins(:recording_singers)
      .where(recording_singers: {recording_id: @orchestra.recordings.select(:id)})
      .distinct

    singers_with_counts = Person.with_attached_image
      .joins(:recording_singers)
      .where(recording_singers: {recording_id: @orchestra.recordings.select(:id)})
      .select("people.*, COUNT(recording_singers.recording_id) AS recording_count")
      .group("people.id")
      .order("recording_count DESC")

    @singers = singers_with_counts.sort_by(&:recording_count).reverse

    @recordings = Recording.where(orchestra_id: @orchestra.id).with_associations
    authorize @orchestra
  end
end
