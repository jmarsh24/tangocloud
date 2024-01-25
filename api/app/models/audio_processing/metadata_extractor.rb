# frozen_string_literal: true

module AudioProcessing
  class MetadataExtractor
    attr_reader :file, :movie

    Metadata = Data.define(
      :duration,
      :bit_rate,
      :bit_depth,
      :bit_rate_mode,
      :codec_name,
      :codec_long_name,
      :sample_rate,
      :channels,
      :title,
      :artist,
      :album,
      :date,
      :track,
      :genre,
      :album_artist,
      :catalog_number,
      :composer,
      :performer,
      :encoded_by,
      :encoder,
      :media_type,
      :lyrics,
      :format,
      :comment,
      :bpm
    ).freeze

    def initialize(file:)
      @file = file.to_s
      @movie = FFMPEG::Movie.new(@file)
    end

    def extract_metadata
      metadata = movie.metadata
      streams = metadata[:streams]
      format = metadata[:format]
      tags = format.dig(:tags).transform_keys(&:downcase)

      audio_stream = streams.find { |stream| stream[:codec_type] == "audio" }

      Metadata.new(
        duration: format[:duration].to_f,
        bit_rate: format[:bit_rate].to_i,
        bit_depth: audio_stream[:bits_per_raw_sample].to_i,
        bit_rate_mode: audio_stream[:bit_rate_mode],
        format: format[:format_name],
        codec_name: audio_stream[:codec_name],
        codec_long_name: audio_stream[:codec_long_name],
        sample_rate: audio_stream[:sample_rate].to_i,
        channels: audio_stream[:channels],
        title: tags.dig(:title),
        artist: tags.dig(:artist),
        album: tags.dig(:album),
        date: tags.dig(:date),
        track: tags.dig(:track),
        genre: tags.dig(:genre),
        album_artist: tags.dig(:album_artist),
        catalog_number: tags.dig(:catalognumber),
        composer: tags.dig(:composer),
        performer: tags.dig(:performer),
        encoded_by: tags.dig(:encoded_by),
        encoder: tags.dig(:encoder),
        media_type: tags.dig(:tmed),
        lyrics: tags.dig(:"lyrics-eng") || tags.dig(:lyrics) || tags.dig(:unsyncedlyrics),
        comment: tags.dig(:comment),
        bpm: tags.dig(:bpm)
      )
    end
  end
end
