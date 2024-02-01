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
      :singer,
      :encoder,
      :media_type,
      :lyrics,
      :format,
      :comment,
      :bpm,
      :ert_number,
      :source,
      :label,
      :lyricist,
      :original_album
    ).freeze

    def initialize(file:)
      @file = file.to_s
      @movie = FFMPEG::Movie.new(file.to_s)
    end

    def extract_metadata
      metadata = movie.metadata
      streams = metadata[:streams]
      format = metadata[:format]
      tags = format.dig(:tags).transform_keys(&:downcase)

      audio_stream = streams.find { |stream| stream[:codec_type] == "audio" }

      comment = comment || tags.dig(:description) || tags.dig(:tit3)

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
        performer: tags.dig(:performer),
        encoded_by: tags.dig(:encoded_by),
        encoder: tags.dig(:encoder),
        media_type: tags.dig(:tmed),
        lyrics: tags.dig(:"lyrics-eng") || tags.dig(:lyrics) || tags.dig(:unsyncedlyrics),
        comment:,
        record_label: tags.dig(:publisher),
        singer: tags.dig(:singer),
        bpm: tags.dig(:bpm),
        ert_number: ert_number(comment),
        source: source(comment),
        label: label(comment),
        lyricist: extract_roles(tags.dig(:composer)).lyricist,
        composer: extract_roles(tags.dig(:composer)).composer,
        original_album: original_album(comment)
      )
    end

    def ert_number(comment)
      comment.match(/id: (\w+-\d+)/)&.captures&.first&.split("-")&.last.to_i
    end

    def source(comment)
      source = comment.match(/source: (\w+)/)&.captures&.first

      return "TangoTunes" if source == "tt"
      return "TangoTimeTravel" if source == "ttt"

      nil
    end

    def label(comment)
      comment.match(/label: (\w+)/)&.captures&.first
    end

    def original_album(comment)
      match = comment.match(/original_album: (.*?)(?:\s*\||\r\n|$)/)
      match&.captures&.first
    end

    def extract_roles(composer_tag)
      composer = extract_role(composer_tag, /composer:\s*([^|]+)/i)
      lyricist = extract_role(composer_tag, /lyricist:\s*([^|]+)/i)

      Data.define(:composer, :lyricist).new(composer:, lyricist:)
    end

    def extract_role(tag, regex)
      match = tag.match(regex)
      match ? match[1].strip : nil
    end
  end
end
