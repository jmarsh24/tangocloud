class ElRecodoEmptyPage < ApplicationRecord
  validates :ert_number, presence: true, uniqueness: true
end

# == Schema Information
#
# Table name: el_recodo_empty_pages
#
#  id         :bigint           not null, primary key
#  ert_number :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
