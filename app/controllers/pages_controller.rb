class PagesController < ApplicationController
  layout "marketing"
  skip_after_action :verify_authorized, :verify_policy_scoped

  def home
  end

  def privacy
  end

  def terms
  end

  def data_deletion
  end
end
