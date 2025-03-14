class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [ :show, :edit, :update, :destroy, :restore, :deactivate, :activate, :block, :unblock, :follow, :unfollow ]
  before_action :authorize_profile, only: [ :edit, :update, :destroy ]
  include ProfilesHelper

  # GET /profiles or /profiles.json
  def index
    @profiles = Profile.where.not(deleted_at: nil)
  end

  def my_profile
    # Find the current user's profile
    @profile = current_user.profile if current_user

    if @profile.nil?
      # Create a new profile if one doesn't exist
      if current_user
        # Create and save the profile first
        @profile = current_user.build_profile
        @profile.save

        # Now it has an ID and can be used in a URL
        redirect_to new_profile_path(@profile), notice: "Let's set up your profile!"
        return
      else
        redirect_to new_user_session_path, alert: "Please sign in to view your profile"
        return
      end
    end

    # Use the same view as show
    render :show
  end

  def increment_views
    @profile = Profile.find(params[:id])
    @profile.increment!(:profile_views_count) if current_user && current_user != @profile.user
    head :ok
  end

  # GET /profiles/1 or /profiles/1.json

  def show
    @profile = Profile.find(params[:id])
    @user = @profile.user

    # Increment view count if it's not the profile owner
    if current_user != @user
      @profile.increment!(:profile_views_count) unless @profile.profile_views_count.nil?
      # Update last seen timestamp
      @profile.update(profile_last_seen_at: Time.current)
    end
  end



  # GET /profiles/new
  def new
    if current_user.profile.present?
      # Redirect to edit if user already has a profile
      redirect_to edit_profile_path(current_user.profile),
        notice: "You already have a profile. You can edit it here."
      return
    end

    # Only build a new profile if user doesn't have one
    @profile = current_user.build_profile
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles or /profiles.json
  def create
    @profile = current_user.build_profile(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: "Profile was successfully created." }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

# PATCH/PUT /profiles/1 or /profiles/1.json
def update
  respond_to do |format|
    if @profile.update(profile_params)
      handle_notification_preferences
      format.html { redirect_to @profile, notice: "Profile was successfully updated." }
      format.json { render :show, status: :ok, location: @profile }
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @profile.errors, status: :unprocessable_entity }
    end
  end
end

  # DELETE /profiles/1 or /profiles/1.json
  def destroy
    # Soft delete instead of hard delete
    @profile.update(deleted_at: Time.current)

    respond_to do |format|
      format.html { redirect_to profiles_path, status: :see_other, notice: "Profile was successfully archived." }
      format.json { head :no_content }
    end
  end

  # Restore a soft-deleted profile
  def restore
    if @profile.restore!
      redirect_to @profile, notice: "Profile was successfully restored."
    else
      redirect_to profiles_path, alert: "Could not restore profile."
    end
  end

  def deactivate
    # Implement deactivation logic
    if @profile.update(active: false)
      # Optionally sign out the user
      sign_out(current_user) if current_user == @profile.user
      redirect_to root_path, notice: "Your profile has been deactivated."
    else
      redirect_to edit_profile_path(@profile), alert: "Unable to deactivate profile."
    end
  end

  def activate
    # Implement activation logic
    if @profile.update(active: true)
      redirect_to @profile, notice: "Your profile has been activated."
    else
      redirect_to edit_profile_path(@profile), alert: "Unable to activate profile."
    end
  end

  def block
    # Implement blocking logic
    if current_user.block(@profile.user)
      redirect_to @profile, notice: "User has been blocked."
    else
      redirect_to @profile, alert: "Unable to block user."
    end
  end

  def unblock
    # Implement unblocking logic
    if current_user.unblock(@profile.user)
      redirect_to @profile, notice: "User has been unblocked."
    else
      redirect_to @profile, alert: "Unable to unblock user."
    end
  end

  def follow
    # Implement follow logic
    if current_user.follow(@profile.user)
      redirect_to @profile, notice: "User has been followed."
    else
      redirect_to @profile, alert: "Unable to follow user."
    end
  end

  def unfollow
    # Implement unfollow logic
    if current_user.unfollow(@profile.user)
      redirect_to @profile, notice: "User has been unfollowed."
    else
      redirect_to @profile, alert: "Unable to unfollow user."
    end
  end

  private

  # Set the profile, handling potential scenarios
  def set_profile
    @profile = if params[:id]
      Profile.find(params[:id])
    else
      current_user.profile
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to profiles_path, alert: "Profile not found."
  end

  # Authorize profile access
  def authorize_profile
    unless @profile.user == current_user
      redirect_to profiles_path, alert: "You are not authorized to perform this action."
    end
  end

  # Strong parameters with comprehensive whitelisting
  def profile_params
    params.require(:profile).permit(
      :first_name,
      :last_name,
      :profile_username,
      :profile_phone_number,
      :profile_date_of_birth,
      :profile_bio,
      :profile_location,
      :profile_cover_image,
      :profile_website,
      :profile_gender,
      :profile_language,
      :profile_views_count,
      :profile_last_seen_at,
      :profile_verification_status,
      :profile_referral_code,
      :profile_notifications,
      :deleted_at,
      :profile_completion,
      profile_social_links: {},
      profile_privacy_settings: {},
      profile_tags: [],
      profile_interests: [],
    )
  end

  def handle_notification_preferences
    return unless params[:email_notifications].present? || params[:push_notifications].present? || params[:in_app_notifications].present?

    preferences = @profile.notification_preferences
    preferences["email"] = params[:email_notifications] == "1"
    preferences["push"] = params[:push_notifications] == "1"
    preferences["in_app"] = params[:in_app_notifications] == "1"
    @profile.profile_notifications = preferences.to_json
  end
end
