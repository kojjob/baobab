module AuthenticationErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Devise::MissingCredentials, with: :handle_missing_credentials
    rescue_from Devise::InvalidCredentials, with: :handle_invalid_credentials
    rescue_from Devise::LockedStrategy, with: :handle_locked_account
  end

  private

  def handle_missing_credentials
    flash.now[:alert] = "Please provide both email and password."
    render_error_stream("login_errors", "Missing Credentials")
  end

  def handle_invalid_credentials
    # Increment failed login attempts
    increment_failed_attempts

    flash.now[:alert] = "Invalid email or password. Please try again."
    render_error_stream("login_errors", "Invalid Credentials")
  end

  def handle_locked_account
    flash.now[:alert] = "Your account has been locked due to multiple failed login attempts. Please reset your password or contact support."
    render_error_stream("login_errors", "Account Locked")
  end

  def increment_failed_attempts
    # You can implement a custom tracking mechanism
    # This could be a simple counter in the session or a more robust tracking in the database
    session[:failed_login_attempts] ||= 0
    session[:failed_login_attempts] += 1

    # Optional: Lock the account after a certain number of attempts
    if session[:failed_login_attempts] >= 5
      # Logic to lock the account
      current_user&.lock_access!
    end
  end

  def render_error_stream(stream_name, error_type)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            "error_container",
            partial: "shared/error_message",
            locals: {
              message: flash[:alert],
              type: error_type
            }
          )
        ]
      end
      format.html { render :new }
    end
  end
end
