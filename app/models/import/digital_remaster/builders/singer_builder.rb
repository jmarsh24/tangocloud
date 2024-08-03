module Import
  module DigitalRemaster
    module Builders
      class SingerBuilder
        Singer = Data.define(:person, :soloist).freeze

        def initialize(name:)
          @name = name
        end

        def build
          return [] if @artist.blank?

          @artist.split(",").map(&:strip).filter_map do |singer_name|
            next if singer_name.casecmp("instrumental").zero?

            if singer_name.start_with?("Dir. ")
              singer_name = singer_name.sub("Dir. ", "").strip
              singer = Person.find_or_initialize_by(name: singer_name)
              Singer.new(person: singer, soloist: true)
            else
              singer = Person.find_or_initialize_by(name: singer_name)
              Singer.new(person: singer, soloist: false)
            end
          end
        end
      end
    end
  end
end
