class UserActivity::Listen < ApplicationRecord
  self.table_name = "listens"
  belongs_to :history, class_name: "UserActivity::History"
  belongs_to :track
end
