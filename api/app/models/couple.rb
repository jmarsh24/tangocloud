class Couple < ApplicationRecord
  belongs_to :dancer
  belongs_to :partner, class_name: "Dancer"
  has_many :couple_videos, dependent: :destroy
  has_many :videos, through: :couple_videos

  validates :dancer_id, presence: true
  validates :partner_id, presence: true
  validates :dancer_id, uniqueness: {scope: :partner_id}
  validate :dancer_id_greater_than_partner_id

  private

  def dancer_greater_than_partner
    return if dancer.nil? || partner.nil?

    errors.add(:dancer_id, "dancer should be greater than partner") if dancer.id < partner.id
  end
end

# == Schema Information
#
# Table name: couples
#
#  id         :uuid             not null, primary key
#  dancer_id  :uuid             not null
#  partner_id :uuid             not null
#
