module Titleizable
  extend ActiveSupport::Concern

  class_methods do
    def custom_titleize(str)
      str.split.map do |word|
        if word.include?("'")
          word.split("'").map(&:capitalize).join("'")
        else
          word.capitalize
        end
      end.join(" ")
    end
  end
end
