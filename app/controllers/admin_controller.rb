class AdminController < ApplicationController
  skip_after_action :verify_policy_scoped, :verify_authorized
  before_action :require_admin!

  def require_admin!
    unless current_user.admin?
      redirect_to root_path, alert: "You must be an admin to do that."
    end
  end
end
