class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin_access
  layout "admin"

  private

  def authorize_admin_access
    # Allow access to the user's own content or admin users
    unless current_user.admin? || controller_name == "posts" && action_name.in?(%w[index show new create edit update])
      redirect_to root_path, alert: "You are not authorized to access this area."
    end
  end
end
