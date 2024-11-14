class UpdatePopularityScoresJob < ApplicationJob
  queue_as :statistics

  def perform
    max_count = Recording.maximum(:playlists_count) + Recording.maximum(:tandas_count)
    return if max_count.zero?

    Recording.update_all(
      "popularity_score = ROUND((CAST(playlists_count + tandas_count AS numeric) / #{max_count}) * 100, 2)"
    )
  end
end
