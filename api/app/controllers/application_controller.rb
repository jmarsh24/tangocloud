class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  after_action :verify_authorized, unless: :devise_controller?
end
