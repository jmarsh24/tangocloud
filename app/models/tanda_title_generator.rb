class TandaTitleGenerator
  DEFAULT_TITLE = "My New Tanda"

  def self.generate_from_recordings(recording_group, position = nil)
    orchestra_names = recording_group.map { |recording| recording.orchestra.display_name }.uniq
    singer_names = recording_group.map { |recording| recording.singers.map { |singer| singer.display_name } }.flatten.compact.uniq
    earliest_year = recording_group.map(&:year).min
    latest_year = recording_group.map(&:year).max

    # Determine the year range format
    year_part = (earliest_year == latest_year) ? earliest_year.to_s : "#{earliest_year} - #{latest_year}"

    if orchestra_names.size == 1
      # For a single orchestra
      orchestra_name = orchestra_names.first
      singer_part = singer_names.empty? ? "Instrumental" : singer_names.join(", ")
      title = "#{orchestra_name} - #{singer_part} - #{year_part}"
    else
      # For mixed tanda, exclude singers
      title = "Mixed Tanda - #{orchestra_names.join(", ")} - #{year_part}"
    end

    # Append position if provided
    title += " T#{position}" if position.present?
    title
  end

  def self.generate_new_title_for_user(user)
    user_tandas = user.tandas.where("title LIKE ?", "#{DEFAULT_TITLE}%")

    # Extract existing numbers from titles like "My New Tanda #1"
    existing_numbers = user_tandas.filter_map do |tanda|
      match = tanda.title.match(/#(\d+)$/)
      match[1].to_i if match
    end

    # Determine the next number to use
    next_number = existing_numbers.empty? ? 1 : existing_numbers.max + 1
    "#{DEFAULT_TITLE} ##{next_number}"
  end
end
