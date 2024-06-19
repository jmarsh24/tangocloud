class PagesController < ApplicationController
  skip_after_action :verify_authorized

  def home
  end

  def privacy
  end

  def terms
  end

  def data_deletion
  end
end
