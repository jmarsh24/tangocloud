class PagesController < ApplicationController
  layout "marketing"
  skip_after_action :verify_authorized
  skip_before_action :authenticate_user!

  def home
  end

  def privacy
  end

  def terms
  end

  def data_deletion
  end
end
