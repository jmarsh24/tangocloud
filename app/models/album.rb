class Album < ApplicationRecord
  has_many :digital_remasters, dependent: :destroy

  validates :title, presence: true

  has_one_attached :album_art

  def export_filename
    "#{title.parameterize}_#{id}"
  end

  def export_filename
    "#{title.parameterize}_#{id}"
  end
end

# == Schema Information
#
# Table name: albums
#
#  id           :uuid             not null, primary key
#  title        :string           not null
#  description  :text
#  release_date :date
#  external_id  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
