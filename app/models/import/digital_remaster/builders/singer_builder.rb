module Import
  module DigitalRemaster
    module Builders
      class SingerBuilder
        Singer = Data.define(:person, :soloist).freeze

        def initialize(name:)
          @name = name
        end

        def build
          return [] if @name.blank?

          @name.split(",").map(&:strip).filter_map do |name|
            next if name.casecmp("instrumental").zero?

            if name.start_with?("Dir. ")
              name = name.sub("Dir. ", "").strip
              person = Person.find_or_create_by_normalized_name!(name)
              Singer.new(person:, soloist: true)
            else
              person = Person.find_or_create_by_normalized_name!(name)
              Singer.new(person:, soloist: false)
            end
          end
        end
      end
    end
  end
end
