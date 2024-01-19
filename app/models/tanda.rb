# frozen_string_literal: true

# == Schema Information
#
# Table name: tandas
#
#  id                :integer          not null, primary key
#  name              :string           not null
#  description       :string
#  public            :boolean          default(TRUE), not null
#  audio_transfer_id :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Tanda < ApplicationRecord
  belongs_to :audio_transfer

  validates :name, presence: true
  validates :public, inclusion: {in: [true, false]}
  validates :audio_transfer_id, presence: true
  validates :audio_transfer_id, uniqueness: true
  validates :audio_transfer_id, uniqueness: {scope: :name}
end
