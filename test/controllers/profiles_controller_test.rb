require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  # Authenticate user before tests if required
  include Devise::Test::IntegrationHelpers

  setup do
    # Assuming you have a profile fixture
    @profile = profiles(:one)

    # If using Devise, sign in a user
    @user = users(:one)
    sign_in @user
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
      post profiles_url, params: {
        profile: {
          deleted_at: @profile.deleted_at,
          first_name: "John",
          last_name: "Doe",
          profile_bio: "Test bio",
          profile_completion: 50,
          profile_date_of_birth: Date.today - 25.years,
          profile_gender: @profile.profile_gender,
          profile_interests: [ "tech", "sports" ],
          profile_language: "en",
          profile_last_seen_at: Time.current,
          profile_location: "Accra",
          profile_phone_number: "+233540123456",
          profile_privacy_settings: {},
          profile_referral_code: "TESTCODE",
          profile_social_links: {},
          profile_tags: [ "developer" ],
          profile_username: "johndoe",
          profile_verification_status: 0,
          profile_views_count: 0,
          profile_website: "https://example.com"
        }
      }
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
    patch profile_url(@profile), params: {
      profile: {
        first_name: "Updated Name",
        profile_bio: "Updated bio"
      }
    }
    assert_redirected_to profile_url(@profile)

    # Optionally, reload and check updates
    @profile.reload
    assert_equal "Updated Name", @profile.first_name
  end

  test "should destroy profile" do
    assert_difference("Profile.count", -1) do
      delete profile_url(@profile)
    end

    assert_redirected_to profiles_url
  end

  # Additional tests for edge cases
  test "should not create profile with invalid data" do
    assert_no_difference("Profile.count") do
      post profiles_url, params: {
        profile: {
          first_name: "",
          profile_username: ""
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
