class AdminController < ApplicationController
  skip_after_action :verify_authorized
  before_action :require_admin!
end
