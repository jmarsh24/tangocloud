class CompositionRole < ApplicationRecord
  enum :role, {composer: "composer", lyricist: "lyricist"}

  belongs_to :person
  belongs_to :composition
end

# == Schema Information
#
# Table name: composition_roles
#
#  id             :integer          not null, primary key
#  role           :composition_role not null
#  person_id      :integer          not null
#  composition_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
