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
      :record_label,
      :encoded_by,
      :singers,
      :media_type,
      :lyrics,
      :format,
      :bpm,
      :ert_number,
      :source,
      :lyricist,
      :artist_sort
    ).freeze

    def initialize(file:)
      @file = file
      @movie = FFMPEG::Movie.new(file.path)
    end

    def extract
      metadata = movie.metadata
      streams = metadata.dig(:streams)
      format = metadata.dig(:format)
      tags = format&.dig(:tags)&.transform_keys(&:downcase) || {}
      audio_stream = streams.find { |stream| stream.dig(:codec_type) == "audio" }
      Metadata.new(
        duration: format.dig(:duration).to_f,
        bit_rate: format.dig(:bit_rate).to_i,
        bit_depth: audio_stream.dig(:bits_per_raw_sample).to_i,
        bit_rate_mode: audio_stream.dig(:bit_rate_mode),
        format: format.dig(:format_name),
        codec_name: audio_stream.dig(:codec_name),
        codec_long_name: audio_stream.dig(:codec_long_name),
        sample_rate: audio_stream.dig(:sample_rate).to_i,
        channels: audio_stream.dig(:channels),
        title: tags.dig(:title),
        artist: tags.dig(:artist).split("/").map(&:strip),
        album: tags.dig(:album),
        date: tags.dig(:date) || tags.dig(:tdat) || tags.dig(:tyer),
        track: tags.dig(:track),
        genre: tags.dig(:genre),
        album_artist: tags.dig(:album_artist),
        catalog_number: tags.dig(:catalognumber),
        performer: tags.dig(:performer),
        encoded_by: tags.dig(:encoded_by),
        media_type: tags.dig(:tmed),
        lyrics: tags.dig(:"lyrics-eng") || tags.dig(:lyrics) || tags.dig(:unsyncedlyrics),
        record_label: tags.dig(:organization),
        bpm: tags.dig(:bpm),
        ert_number: tags.dig(:barcode)&.match(/\d+/)&.[](0).to_i,
        source: tags.dig(:grouping),
        lyricist: tags.dig(:lyricist),
        composer: tags.dig(:composer),
        artist_sort: tags.dig(:artistsort)
      )
    end
  end
end
