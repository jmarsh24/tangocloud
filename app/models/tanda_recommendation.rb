class TandaRecommendation
  def initialize(tanda)
    @tanda = tanda
    @tanda_recordings = tanda.tanda_recordings.includes(recording: [:composition, :orchestra, :genre, :singers])
    @recordings = @tanda_recordings.map(&:recording)
    @recording_ids = @recordings.map(&:id)
  end

  def recommend_recordings(limit: 10)
    return [] if @tanda_recordings.blank?

    recommended_recordings = recommend_from_tandas(limit:)

    additional_recommendations = recommend_from_orchestra_and_singers(limit:)

    (recommended_recordings + additional_recommendations).uniq.shuffle.take(limit)
  end

  private

  def recommend_from_tandas(limit:)
    tandas = Tanda.joins(:tanda_recordings).where(tanda_recordings: {recording_id: @recording_ids}).distinct

    next_recordings = TandaRecording.where(tanda_id: tandas.select(:id))
      .where.not(recording_id: @recording_ids)
      .select(:recording_id, :position, :tanda_id)

    last_recording = @recordings.last
    last_positions = TandaRecording.where(recording_id: last_recording.id, tanda_id: tandas.select(:id)).pluck(:tanda_id, :position).to_h

    scores = calculate_scores(next_recordings, last_positions)
    recommended_ids = scores.sort_by { |_, score| -score }.map(&:first).take(limit)

    Recording.where(id: recommended_ids)
  end

  def recommend_from_orchestra_and_singers(limit:)
    orchestra_ids = @tanda_recordings.joins(:recording).select("DISTINCT recordings.orchestra_id").pluck(:orchestra_id)
    singer_ids = @tanda_recordings.flat_map { |tr| tr.recording.singers.pluck(:id) }.uniq
    recording_ids = @tanda_recordings.pluck(:recording_id)

    year_range = (@tanda_recordings.first.recording.year - 5)..(@tanda_recordings.first.recording.year + 5)

    # Recordings with both matching orchestra and singers
    recordings_with_both = Recording
      .joins(:singers)
      .where(orchestra_id: orchestra_ids, singers: {id: singer_ids})
      .where.not(id: recording_ids)
      .where(year: year_range)

    # Recordings with matching orchestra but not necessarily singers
    recordings_with_orchestra = Recording
      .where(orchestra_id: orchestra_ids)
      .where.not(id: recording_ids)
      .where(year: year_range)

    # Recordings with matching singers but not necessarily orchestra
    recordings_with_singers = Recording
      .joins(:singers)
      .where(singers: {id: singer_ids})
      .where.not(id: recording_ids)
      .where(year: year_range)

    # Combine results with prioritization
    (recordings_with_both.to_a * 2 + recordings_with_orchestra.to_a + recordings_with_singers.to_a)
      .uniq
      .sort_by(&:popularity_score)
      .reverse
      .take(limit)
  end

  def calculate_scores(next_recordings, last_positions)
    scores = Hash.new(0)

    next_recordings.each do |next_recording|
      tanda_id = next_recording.tanda_id
      if last_positions[tanda_id]
        proximity = 1.0 / (1 + (next_recording.position - last_positions[tanda_id]).abs)
        scores[next_recording.recording_id] += proximity
      end
    end

    scores
  end
end
