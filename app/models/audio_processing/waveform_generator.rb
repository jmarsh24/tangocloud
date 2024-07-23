module AudioProcessing
  class WaveformGenerator
    attr_reader :waveform, :image

    Waveform = Data.define(:version, :channels, :sample_rate, :samples_per_pixel, :bits, :length, :data).freeze
    def initialize(file:)
      @file = file
    end

    def generate
      audio_path = @file.path
      movie = FFMPEG::Movie.new(audio_path)

      if movie.audio_codec != "mp3"
        Tempfile.create(["converted-", ".mp3"]) do |tempfile|
          movie.transcode(tempfile.path, {audio_codec: "mp3"})
          data = generate_waveform_json(tempfile.path)
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

    def generate_image(width: 800, height: 150)
      waveform_data = generate.data
      image = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)
      tempfile = Tempfile.new(["waveform-", ".png"])

      waveform_data.each_with_index do |point, index|
        x = (index.to_f * width / waveform_data.length).to_i
        y1 = ((1 - point.to_f) * height / 2).to_i
        y2 = ((1 + point.to_f) * height / 2).to_i
        image.line(x, y1, x, y2, ChunkyPNG::Color::BLACK)
      end
      image.save(tempfile.path, interlace: true)
      tempfile
    end

    private

    def generate_waveform_json(audio_path)
      Tempfile.create(["audios", ".json"]) do |json_tempfile|
        command = ["audiowaveform", "-i", audio_path, "-o", json_tempfile.path, "-z", "1024", "--amplitude-scale", "3.5"]
        _stdout, stderr, status = Open3.capture3(*command)
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
