class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pagy::Frontend
  include Pagy::Backend



  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :username, :phone, :terms_of_service, :full_name,
    :phone_number,
    :date_of_birth,
    :region,
    :city,
    :address ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :username, :phone, :terms_of_service, :full_name,
    :phone_number,
    :date_of_birth,
    :region,
    :city,
    :address ])
  end
end
