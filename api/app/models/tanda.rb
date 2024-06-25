class Tanda < ApplicationRecord
  has_many :tanda_recordings, dependent: :destroy

  validates :name, presence: true
  validates :public, inclusion: {in: [true, false]}
end

# == Schema Information
#
# Table name: tandas
#
#  id          :uuid             not null, primary key
#  name        :string           not null
#  description :string
#  public      :boolean          default(TRUE), not null
#  user_id     :uuid             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
