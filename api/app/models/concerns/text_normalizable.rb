# frozen_string_literal: true

module TextNormalizable
  extend ActiveSupport::Concern

  class_methods do
    def normalize_text_field(text)
      return text unless text.is_a?(String)

      normalized_text = I18n.transliterate(text) # Transliterate
      normalized_text.downcase!                  # Convert to lowercase
      normalized_text.gsub!(/['’`]/, "")         # Remove apostrophes and similar characters
      normalized_text.gsub!(/\s+/, " ")          # Replace multiple spaces with a single space
      normalized_text.strip!                     # Remove leading and trailing spaces
      normalized_text
    end
  end
end
