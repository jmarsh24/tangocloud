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
      :comments,
      :bpm,
      :ert_number,
      :source,
      :lyricist,
      :original_album
    ).freeze

    def initialize(file:)
      @file = file.to_s
      @movie = FFMPEG::Movie.new(file.to_s)
    end

    def extract_metadata
      metadata = movie.metadata
      streams = metadata.dig(:streams)
      format = metadata.dig(:format)
      tags = format.dig(:tags)&.transform_keys(&:downcase) || {}
      audio_stream = streams.find { |stream| stream.dig(:codec_type) == "audio" }
      comments = comments || tags.dig(:description) || tags.dig(:tit3)
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
        comments:,
        record_label: record_label(comments),
        singer: tags.dig(:artist),
        bpm: tags.dig(:bpm),
        ert_number: ert_number(comments),
        source: source(comments),
        lyricist: extract_roles(tags.dig(:composer))&.lyricist,
        composer: extract_roles(tags.dig(:composer))&.composer,
        original_album: original_album(comments)
      )
    end

    def ert_number(comments)
      return nil unless comments

      comments.match(/id: (\w+-\d+)/)&.captures&.first&.split("-")&.last.to_i
    end

    def source(comments)
      return nil unless comments

      source = comments.match(/source: (\w+)/)&.captures&.first

      return "TangoTunes" if source == "tt"
      return "TangoTimeTravel" if source == "ttt"

      nil
    end

    def record_label(comments)
      return nil unless comments

      comments.match(/label: ([\w\s]+?) \|/)&.captures&.first
    end

    def original_album(comments)
      return nil unless comments

      match = comments.match(/original_album: (.*?)(?:\s*\||\r\n|$)/)
      match&.captures&.first
    end

    def extract_roles(composer_tag)
      return nil unless composer_tag

      composer = extract_role(composer_tag, /composer:\s*([^|]+)/i)
      lyricist = extract_role(composer_tag, /lyricist:\s*([^|]+)/i)

      Data.define(:composer, :lyricist).new(composer:, lyricist:)
    end

    def extract_role(tag, regex)
      return nil unless tag

      match = tag.match(regex)
      match ? match[1].strip : nil
    end
  end
end
