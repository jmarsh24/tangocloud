module TextNormalizable
  extend ActiveSupport::Concern

  class_methods do
    def normalize_text_field(text)
      return text unless text.is_a?(String)

      normalized_text = I18n.transliterate(text).downcase.strip
      normalized_text.gsub("' ", "").gsub("'", "").gsub("?", "")
    end
  end
end
