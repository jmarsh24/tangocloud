module NameUtils
  class NameNormalizer
    def self.normalize(name)
      # Downcase the string to ensure uniformity
      normalized = name.downcase

      # Replace periods with spaces to separate initials
      normalized.tr!(".", " ")

      # Replace different types of apostrophes and similar characters with nothing (remove them)
      normalized.gsub!(/[’`´‘']/, "")

      # Remove any leading or trailing spaces
      normalized.strip!

      # Transliterate to remove accents/diacritics (e.g., 'Á' -> 'A')
      normalized = I18n.transliterate(normalized)

      # Replace hyphens with spaces to separate parts of the name
      normalized.tr!("-", " ")

      # Normalize Unicode (NFC) to ensure consistent character composition
      normalized = normalized.unicode_normalize(:nfc)

      # Remove any non-alphanumeric characters except spaces
      normalized.gsub!(/[^a-z0-9\s]/, "")

      # Reduce multiple spaces to a single space
      normalized.gsub!(/\s+/, " ")

      # Remove extra spaces again, in case there were any left after cleaning
      normalized.strip!

      normalized
    end
  end
end
