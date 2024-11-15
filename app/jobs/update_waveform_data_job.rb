class UpdateWaveformDataJob < ApplicationJob
  queue_as :background

  def perform(digital_remaster)
    Rails.logger.info("Processing DigitalRemaster ##{digital_remaster.id}")

    unless digital_remaster.audio_file&.file&.attached?
      Rails.logger.warn("Skipping DigitalRemaster ##{digital_remaster.id}: No attached audio file")
      return
    end

    waveform = digital_remaster.waveform || digital_remaster.create_waveform

    digital_remaster.audio_file.file.blob.open do |tempfile|
      waveform_generator = AudioProcessing::WaveformGenerator.new

      waveform_data = waveform_generator.generate(tempfile.path)

      waveform.create_waveform_datum!(
        data: waveform_data.to_json
      )

      waveform_generator.generate_image(tempfile.path) do |waveform_image|
        waveform.image.attach(
          io: File.open(waveform_image.path),
          filename: "waveform_#{digital_remaster.id}.png",
          content_type: "image/png"
        )
      end

      waveform.save!
      Rails.logger.info("Successfully processed DigitalRemaster ##{digital_remaster.id}")
    end
  rescue => e
    Rails.logger.error("Error processing DigitalRemaster ##{digital_remaster.id}: #{e.message}")
    e.backtrace.each { |line| Rails.logger.error(line) }
  end
end
