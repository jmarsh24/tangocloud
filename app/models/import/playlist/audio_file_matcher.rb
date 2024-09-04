module Import
  module Playlist
    class AudioFileMatcher
      SUPPORTED_FORMATS = ["mp3", "flac", "m4a", "wav", "aiff", "aif"].freeze

      def initialize(path)
        @path = path
      end

      def recordings
        matched_recordings = []

        File.open(@path).each_line do |line|
          trimmed_line = line.strip
          match_data = trimmed_line.match(/^.*[\/\\]([^\/\\]+)\.(#{SUPPORTED_FORMATS.join("|")})$/i)

          next unless match_data

          filename = "#{match_data[1]}.#{match_data[2]}"
          audio_file = ::AudioFile.find_by(filename:)

          next unless audio_file

          recording = audio_file.digital_remaster.recording
          matched_recordings << recording if recording
        end

        matched_recordings
      end
    end
  end
end
