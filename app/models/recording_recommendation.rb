class RecordingRecommendation
  def initialize(recordings, top_n = 5)
    @recordings = recordings
    @recording_ids = recordings.map(&:id)
    @top_n = top_n
  end

  def recommend_recordings
    return [] if @recordings.blank?

    tandas = Tanda.joins(:tanda_recordings).where(tanda_recordings: {recording_id: @recording_ids}).distinct

    next_recordings = TandaRecording.where(tanda_id: tandas.select(:id))
      .where.not(recording_id: @recording_ids)
      .select(:recording_id, :position, :tanda_id)

    last_recording = @recordings.last
    last_positions = TandaRecording.where(recording_id: last_recording.id, tanda_id: tandas.select(:id)).pluck(:tanda_id, :position).to_h

    scores = calculate_scores(next_recordings, last_positions)

    recommended_ids = scores.sort_by { |_, score| -score }.take(@top_n).map(&:first)

    if recommended_ids
      Recording.where(id: recommended_ids)
    else
      Recording.none
    end
  end

  private

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
