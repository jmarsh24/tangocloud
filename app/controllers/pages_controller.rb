class PagesController < ApplicationController
  skip_after_action :verify_authorized, :verify_policy_scoped
  skip_before_action :authenticate_user!

  def landing
  end

  def privacy
  end

  def terms
  end

  def data_deletion
  end
end
