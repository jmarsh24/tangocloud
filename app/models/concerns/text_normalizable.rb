# frozen_string_literal: true

module TextNormalizable
  extend ActiveSupport::Concern

  class_methods do
    def normalize_text_field(text)
      return text unless text.is_a?(String)

      I18n.transliterate(text).downcase.strip
    end
  end
end
