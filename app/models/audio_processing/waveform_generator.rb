module AudioProcessing
  class WaveformGenerator
    Waveform = Struct.new(:version, :channels, :sample_rate, :samples_per_pixel, :bits, :length, :data).freeze

    def generate(path)
      movie = FFMPEG::Movie.new(path)

      if movie.audio_codec != "mp3"
        Tempfile.create(["converted-", ".mp3"]) do |tempfile|
          movie.transcode(tempfile.path, {audio_codec: "mp3"})
          data = generate_waveform_json(tempfile.path)
          return Waveform.new(
            version: data["version"],
            channels: data["channels"],
            sample_rate: data["sample_rate"],
            samples_per_pixel: data["samples_per_pixel"],
            bits: data["bits"],
            length: data["length"],
            data: data["data"]
          )
        end
      else
        data = generate_waveform_json(path)
        Waveform.new(
          version: data["version"],
          channels: data["channels"],
          sample_rate: data["sample_rate"],
          samples_per_pixel: data["samples_per_pixel"],
          bits: data["bits"],
          length: data["length"],
          data: data["data"]
        )
      end
    end

    def generate_image(path, width: 800, height: 150)
      waveform = generate(path)
      waveform_data = waveform.data
      channels = waveform.channels

      if channels > 1
        data_length = waveform_data.map(&:length).min
        waveform_data = (0...data_length).map do |i|
          sum = waveform_data.reduce(0.0) { |acc, ch_data| acc + ch_data[i].to_f }
          sum / channels
        end
      else
        waveform_data = waveform_data.map(&:to_f)
      end

      Tempfile.create(["waveform-", ".png"]) do |tempfile|
        image = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)

        waveform_data.each_with_index do |point, index|
          x = (index.to_f * width / waveform_data.length).to_i
          y1 = ((1 - point.to_f) * height / 2).to_i
          y2 = ((1 + point.to_f) * height / 2).to_i
          image.line(x, y1, x, y2, ChunkyPNG::Color::BLACK)
        end

        image.save(tempfile.path, interlace: true)
        yield tempfile if block_given?
      end
    end

    private

    def generate_waveform_json(audio_path)
      Tempfile.create(["audios", ".json"]) do |json_tempfile|
        command = [
          "audiowaveform",
          "-i", audio_path,
          "-o", json_tempfile.path,
          "-z", "1024",
          "--amplitude-scale", "3.5",
          "--split-channels"
        ]
        _stdout, stderr, status = Open3.capture3(*command)
        if status.success?
          data = JSON.parse(File.read(json_tempfile.path))

          data_array = data["data"]
          max_val = data_array.max.to_f
          digits = 2
          new_data = data_array.map { |x| (x.to_f / max_val).round(digits) }

          channels = data["channels"].to_i
          if channels > 1
            new_data = deinterleave(new_data, channels)
          end

          data["data"] = new_data
          return data
        else
          raise "Command failed with error: #{stderr}"
        end
      end
    end

    def deinterleave(data, channel_count)
      deinterleaved = (0...(channel_count * 2)).map do |idx|
        data.each_slice(channel_count * 2).map { |slice| slice[idx] }.compact
      end

      new_data = []

      channel_count.times do |ch|
        idx1 = 2 * ch
        idx2 = 2 * ch + 1
        deinterleaved_idx1 = deinterleaved[idx1]
        deinterleaved_idx2 = deinterleaved[idx2]
        ch_data = deinterleaved_idx1.zip(deinterleaved_idx2).flatten.compact
        new_data << ch_data
      end

      new_data
    end
  end
end
