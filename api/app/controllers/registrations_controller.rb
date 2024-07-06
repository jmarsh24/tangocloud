class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:edit, :update]

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [user_preference_attributes: [:avatar]])
    devise_parameter_sanitizer.permit(:account_update, keys: [user_preference_attributes: [:avatar]])
  end
end
