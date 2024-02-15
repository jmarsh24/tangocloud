module AudioProcessing
  class WaveformGenerator
    def initialize(audio_file)
      @audio_file = audio_file
      @set_filepath = File.join(Rails.root, "tmp/audios/#{@audio.id}/#{@audio_file.filename}")
    end

    def generate
      generate_json
      generate_image
      generate_audioforms
    end

    def generate_audioform(zoom:, scale:, width:, height:)
      generate_bar_command = <<-SH
          audiowaveform -i "#{@set_filepath}" \
            -o "#{@set_filepath}.#{zoom}.#{scale}.bars.#{width}.#{height}.png" \
            -z #{zoom} --amplitude-scale #{scale} -w #{width} -h #{height} --no-axis-labels --background-color FFFFFF00 \
            --waveform-color 000000FF --waveform-style bars --bar-width 8 --bar-gap 2
      SH
      generate_wave_command = <<-SH
          audiowaveform -i "#{@set_filepath}" \
            -o "#{@set_filepath}.#{zoom}.#{scale}.waves.#{width}.#{height}.png" \
            -z #{zoom} --amplitude-scale #{scale} -w #{width} -h #{height}  \
            --no-axis-labels --background-color FFFFFF00 --waveform-color 000000FF
      SH
      `#{generate_bar_command}`
      `#{generate_wave_command}`

      ["#{@set_filepath}.#{zoom}.#{scale}.bars.#{width}.#{height}.png",
        "#{@set_filepath}.#{zoom}.#{scale}.waves.#{width}.#{height}.png"]
    end

    def generate_json
      filename = "#{@set_filepath}.json"
      return filename if File.exist?(filename)

      generate_json_command = <<-SH
        audiowaveform -i "#{@set_filepath}" \
          -o "#{filename}" \
          -z 1024 --amplitude-scale 3.5
      SH

      `#{generate_json_command}`
      binding.irb
    filename
    end

    def json
      return @json if @json

      generate_json
      @json = JSON.parse(File.read("#{@set_filepath}.json"))
    end

    def generate_image(width: 1000, height: 200)
      image = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)

      json["data"].each_with_index do |point, index|
        x = (index * width / json["length"]).to_i
        y1 = ((1 - point.to_f / 32768) * height / 2).to_i
        y2 = ((1 + point.to_f / 32768) * height / 2).to_i
        image.line(x, y1, x, y2, ChunkyPNG::Color::BLACK)
      end

      filename = "#{@set_filepath}.#{width}.#{height}.waveform.png"
      image.save("#{@set_filepath}.#{width}.#{height}.waveform.png")

      filename
    end
  end
end
