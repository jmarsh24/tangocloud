module AudioProcessing
  class WaveformGenerator
    Waveform = Data.define(:version, :channels, :sample_rate, :samples_per_pixel, :bits, :length, :data).freeze
    def initialize(audio_file)
      @audio_file = audio_file
    end

    def json
      audio_path = @audio_file.path

      if FFMPEG::Movie.new(audio_path).audio_codec != "mp3"
        convert_to_mp3(audio_path) do |converted_file|
          audio_path = converted_file.path
          data = generate_waveform_json(audio_path)
          return Waveform.new(
            data["version"],
            data["channels"],
            data["sample_rate"],
            data["samples_per_pixel"],
            data["bits"],
            data["length"],
            data["data"]
          )
        end
      else

      data = generate_waveform_json(audio_path)
      Waveform.new(
        data["version"],
        data["channels"],
        data["sample_rate"],
        data["samples_per_pixel"],
        data["bits"],
        data["length"],
        data["data"]
      )
      end
    end

    private

    def convert_to_mp3(original_path)
      movie = FFMPEG::Movie.new(original_path)
      converted_path = "#{original_path}.mp3"
      movie.transcode(converted_path, {audio_codec: "mp3"})

      File.open(converted_path) do |file|
        yield file
      end
    end

    def generate_waveform_json(audio_path)
      Tempfile.create(["audios", ".json"]) do |json_tempfile|
        command = "audiowaveform -i '#{audio_path}' -o '#{json_tempfile.path}' -z 1024 --amplitude-scale 3.5"
        _stdout, stderr, status = Open3.capture3(command)
        if status.success?
          data = JSON.parse(File.read(json_tempfile.path))
          data["data"].map! { |value| value.to_f / 32768 }
          return data
        else
          raise "Command failed with error: #{stderr}"
        end
      end
    end
  end
end
