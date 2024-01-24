# frozen_string_literal: true

class String
  def titleize_name
    split(/(\s|-)/).map do |word|  # Split on spaces and hyphens
      if word.include?("'")
        parts = word.split("'")
        parts.map(&:capitalize).join("'")
      elsif word == "-" || word.strip.empty?  # Keep hyphens and spaces as is
        word
      else
        word.capitalize
      end
    end.join
  end
end
