class Tanda < ApplicationRecord
  include Playlistable

  belongs_to :user, optional: true
  has_many :tanda_recordings, dependent: :destroy
  has_many :recordings, through: :tanda_recordings, inverse_of: :tandas
end

# == Schema Information
#
# Table name: tandas
#
#  id              :uuid             not null, primary key
#  title           :string           not null
#  subtitle        :string
#  description     :text
#  slug            :string
#  public          :boolean          default(TRUE), not null
#  system          :boolean          default(FALSE), not null
#  user_id         :uuid
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  playlists_count :integer          default(0), not null
#
