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
      parsed_comments = parse_into_hash(comments)
      parsed_lyricist_and_composer = parse_into_hash(tags.dig(:composer))

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
        record_label: parsed_comments.dig("label"),
        singer: tags.dig(:artist),
        bpm: tags.dig(:bpm),
        ert_number: ert_number(parsed_comments),
        source: source(parsed_comments),
        lyricist: parsed_lyricist_and_composer.dig("lyricist"),
        composer: parsed_lyricist_and_composer.dig("composer"),
        original_album: parsed_comments.dig("original_album")
      )
    end

    def parse_into_hash(comments)
      return {} unless comments

      comments.split("|").each_with_object({}) do |pair, hash|
        key, value = pair.split(":", 2).map(&:strip)
        hash[key.downcase] = value
      end
    end

    def ert_number(parsed_comments)
      ert_str = parsed_comments.dig("id")

      return nil unless ert_str
      ert_str.split("-").last.to_i
    end

    def source(parsed_comments)
      source = parsed_comments.dig("source")&.downcase

      return "TangoTunes" if source == "tt"
      return "TangoTimeTravel" if source == "ttt"
      nil
    end

    def extract_role(tag, regex)
      return nil unless tag

      match = tag.match(regex)
      match ? match[1].strip : nil
    end
  end
end
