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

          filename_prefix = match_data[1]
          
          audio_file = ::AudioFile.where("filename ILIKE ?", "#{filename_prefix}.%").first

          next unless audio_file

          recording = audio_file.digital_remaster.recording
          matched_recordings << recording if recording
        end

        matched_recordings
      end
    end
  end
end
