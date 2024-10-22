module User::Role
  extend ActiveSupport::Concern

  included do
    enum :role, %i[user tester editor admin]
  end

  def can_administer?(record = nil)
    admin? || (record && self == record.creator)
  end

  def can_edit?(record = nil)
    admin? || editor? || (record && self == record.creator)
  end

  def can_view?(record = nil)
    admin? || editor? || tester? || (record && self == record.creator)
  end

  def admin?
    role == "admin"
  end

  def editor?
    role == "editor"
  end

  def tester?
    role == "tester"
  end
end
