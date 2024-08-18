module NameUtils
  class NameParser
    ParsedName = Data.define(:formatted_name, :pseudonym).freeze

    def self.parse(name)
      if name.include?("(") && name.include?(")")
        pseudonym = name[/\(([^)]+)\)/, 1].strip
        formatted_name = NameFormatter.format(name.sub(/\(.*\)/, "").strip)
        ParsedName.new(formatted_name:, pseudonym:)
      else
        ParsedName.new(formatted_name: NameFormatter.format(name), pseudonym: nil)
      end
    end
  end
end
