module AudioProcessing
  class MetadataExtractor
    attr_reader :file, :movie

    Metadata = Data.define(
      :title,
      :artist,
      :album,
      :year,
      :genre,
      :album_artist,
      :album_artist_sort,
      :composer,
      :grouping,
      :catalog_number,
      :lyricist,
      :barcode,
      :date,
      :duration,
      :bit_rate,
      :codec_name,
      :sample_rate,
      :channels,
      :bit_depth,
      :format,
      :organization,
      :replaygain_track_gain,
      :replaygain_track_peak,
      :lyrics
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
        format: format.dig(:format_name),
        codec_name: audio_stream.dig(:codec_name),
        sample_rate: audio_stream.dig(:sample_rate).to_i,
        channels: audio_stream.dig(:channels),
        title: tags.dig(:title),
        artist: tags.dig(:artist),
        album: tags.dig(:album),
        date: tags.dig(:date) || tags.dig(:tdat) || tags.dig(:tyer),
        genre: tags.dig(:genre),
        album_artist: tags.dig(:album_artist),
        catalog_number: tags.dig(:catalognumber),
        lyrics: tags.dig(:"lyrics-eng") || tags.dig(:lyrics) || tags.dig(:unsyncedlyrics) || tags.dig(:"lyrics-xxx"),
        organization: tags.dig(:organization),
        barcode: tags.dig(:barcode),
        lyricist: tags.dig(:lyricist) || tags.dig(:text),
        composer: tags.dig(:composer),
        album_artist_sort: tags.dig(:albumartistsort),
        grouping: tags.dig(:grouping),
        replaygain_track_gain: tags.dig(:replaygain_track_gain),
        replaygain_track_peak: tags.dig(:replaygain_track_peak),
        year: tags.dig(:year)
      )
    end
  end
end
