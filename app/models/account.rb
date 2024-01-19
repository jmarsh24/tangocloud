# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id :integer          not null, primary key
#
class Account < ApplicationRecord
  has_many :users, dependent: :destroy
end
