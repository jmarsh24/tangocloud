module Import
  module Playlist
    class RecordingsGrouper
      def self.group(recordings)
        # Step 1: Group recordings by orchestra while maintaining order
        orchestra_groups = recordings.chunk_while { |prev, curr| prev.orchestra == curr.orchestra }.to_a

        # Step 2: Merge small groups based on genre
        merged_groups = []
        buffer_group = []

        orchestra_groups.each_with_index do |group, index|
          if group.size >= 3
            # Groups of size 3 or more are kept as they are
            merged_groups << group
          else
            # Merge small groups with the same genre
            buffer_group += group
            next_group = orchestra_groups[index + 1]

            # Determine if we should flush the buffer
            if next_group.nil? || next_group.size >= 3 || buffer_group.map(&:genre).uniq.size > 1 || next_group.map(&:genre).uniq != buffer_group.map(&:genre).uniq
              merged_groups << buffer_group
              buffer_group = []
            end
          end
        end

        # Add any remaining recordings in the buffer
        merged_groups << buffer_group unless buffer_group.empty?

        merged_groups
      end
    end
  end
end
