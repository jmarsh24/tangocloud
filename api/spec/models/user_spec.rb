require "rails_helper"

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  verified        :boolean          default(FALSE), not null
#  provider        :string
#  uid             :string
#  username        :string           not null
#  first_name      :string
#  last_name       :string
#  admin           :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
