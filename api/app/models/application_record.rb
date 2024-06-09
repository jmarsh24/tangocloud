class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.datetime_attributes
    @datetime_attributes ||= columns_hash.select {|k,v| v.type == :datetime}.keys.sort
  end
end
