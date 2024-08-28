module NameUtils
  class NameFormatter
    LOWERCASE_WORDS = ["y", "de", "la", "del", "el", "los", "las"].freeze

    def self.format(name)
      capitalize_name(name)
    end

    private_class_method

    def self.capitalize_name(name)
      words = name.split
      words.map!.with_index do |word, index|
        if index.zero? || !LOWERCASE_WORDS.include?(word.downcase)
          capitalize_word(word)
        else
          word.downcase
        end
      end
      words.join(" ")
    end

    def self.capitalize_word(word)
      if word.include?("'")
        parts = word.split("'")
        parts.map(&:capitalize).join("'")
      elsif word.include?(".")
        word # Do not change words with periods (like "F.Lila")
      else
        word.capitalize
      end
    end
  end
end
