class AdminController < ApplicationController
  skip_after_action :verify_authorized
  before_action :require_admin!

  def require_admin!
    unless Current.user&.admin?
      redirect_to root_path, alert: "You must be an admin to do that."
    end
  end
end
