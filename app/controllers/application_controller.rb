class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pagy::Frontend
  include Pagy::Backend
  include Pundit::Authorization


  # Optional: Pundit authorization for all actions
  # after_action :verify_authorized, except: :index
  # after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
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

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end
end
