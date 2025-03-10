require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @profile = profiles(:one)
  end

  test "should get index" do
    get profiles_url
    assert_response :success
  end

  test "should get new" do
    get new_profile_url
    assert_response :success
  end

  test "should create profile" do
    assert_difference("Profile.count") do
      post profiles_url, params: { profile: { deleted_at: @profile.deleted_at, first_name: @profile.first_name, last_name: @profile.last_name, profile_bio: @profile.profile_bio, profile_completion: @profile.profile_completion, profile_date_of_birth: @profile.profile_date_of_birth, profile_gender: @profile.profile_gender, profile_interests: @profile.profile_interests, profile_language: @profile.profile_language, profile_last_seen_at: @profile.profile_last_seen_at, profile_location: @profile.profile_location, profile_phone_number: @profile.profile_phone_number, profile_privacy_settings: @profile.profile_privacy_settings, profile_referral_code: @profile.profile_referral_code, profile_social_links: @profile.profile_social_links, profile_tags: @profile.profile_tags, profile_username: @profile.profile_username, profile_verification_status: @profile.profile_verification_status, profile_views_count: @profile.profile_views_count, profile_website: @profile.profile_website } }
    end

    assert_redirected_to profile_url(Profile.last)
  end

  test "should show profile" do
    get profile_url(@profile)
    assert_response :success
  end

  test "should get edit" do
    get edit_profile_url(@profile)
    assert_response :success
  end

  test "should update profile" do
    patch profile_url(@profile), params: { profile: { deleted_at: @profile.deleted_at, first_name: @profile.first_name, last_name: @profile.last_name, profile_bio: @profile.profile_bio, profile_completion: @profile.profile_completion, profile_date_of_birth: @profile.profile_date_of_birth, profile_gender: @profile.profile_gender, profile_interests: @profile.profile_interests, profile_language: @profile.profile_language, profile_last_seen_at: @profile.profile_last_seen_at, profile_location: @profile.profile_location, profile_phone_number: @profile.profile_phone_number, profile_privacy_settings: @profile.profile_privacy_settings, profile_referral_code: @profile.profile_referral_code, profile_social_links: @profile.profile_social_links, profile_tags: @profile.profile_tags, profile_username: @profile.profile_username, profile_verification_status: @profile.profile_verification_status, profile_views_count: @profile.profile_views_count, profile_website: @profile.profile_website } }
    assert_redirected_to profile_url(@profile)
  end

  test "should destroy profile" do
    assert_difference("Profile.count", -1) do
      delete profile_url(@profile)
    end

    assert_redirected_to profiles_url
  end
end
