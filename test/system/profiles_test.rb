require "application_system_test_case"

class ProfilesTest < ApplicationSystemTestCase
  setup do
    @profile = profiles(:one)
  end

  test "visiting the index" do
    visit profiles_url
    assert_selector "h1", text: "Profiles"
  end

  test "should create profile" do
    visit profiles_url
    click_on "New profile"

    fill_in "Deleted at", with: @profile.deleted_at
    fill_in "First name", with: @profile.first_name
    fill_in "Last name", with: @profile.last_name
    fill_in "Profile bio", with: @profile.profile_bio
    fill_in "Profile completion", with: @profile.profile_completion
    fill_in "Profile date of birth", with: @profile.profile_date_of_birth
    fill_in "Profile gender", with: @profile.profile_gender
    fill_in "Profile interests", with: @profile.profile_interests
    fill_in "Profile language", with: @profile.profile_language
    fill_in "Profile last seen at", with: @profile.profile_last_seen_at
    fill_in "Profile location", with: @profile.profile_location
    fill_in "Profile phone number", with: @profile.profile_phone_number
    fill_in "Profile privacy settings", with: @profile.profile_privacy_settings
    fill_in "Profile referral code", with: @profile.profile_referral_code
    fill_in "Profile social links", with: @profile.profile_social_links
    fill_in "Profile tags", with: @profile.profile_tags
    fill_in "Profile username", with: @profile.profile_username
    fill_in "Profile verification status", with: @profile.profile_verification_status
    fill_in "Profile views count", with: @profile.profile_views_count
    fill_in "Profile website", with: @profile.profile_website
    click_on "Create Profile"

    assert_text "Profile was successfully created"
    click_on "Back"
  end

  test "should update Profile" do
    visit profile_url(@profile)
    click_on "Edit this profile", match: :first

    fill_in "Deleted at", with: @profile.deleted_at.to_s
    fill_in "First name", with: @profile.first_name
    fill_in "Last name", with: @profile.last_name
    fill_in "Profile bio", with: @profile.profile_bio
    fill_in "Profile completion", with: @profile.profile_completion
    fill_in "Profile date of birth", with: @profile.profile_date_of_birth
    fill_in "Profile gender", with: @profile.profile_gender
    fill_in "Profile interests", with: @profile.profile_interests
    fill_in "Profile language", with: @profile.profile_language
    fill_in "Profile last seen at", with: @profile.profile_last_seen_at.to_s
    fill_in "Profile location", with: @profile.profile_location
    fill_in "Profile phone number", with: @profile.profile_phone_number
    fill_in "Profile privacy settings", with: @profile.profile_privacy_settings
    fill_in "Profile referral code", with: @profile.profile_referral_code
    fill_in "Profile social links", with: @profile.profile_social_links
    fill_in "Profile tags", with: @profile.profile_tags
    fill_in "Profile username", with: @profile.profile_username
    fill_in "Profile verification status", with: @profile.profile_verification_status
    fill_in "Profile views count", with: @profile.profile_views_count
    fill_in "Profile website", with: @profile.profile_website
    click_on "Update Profile"

    assert_text "Profile was successfully updated"
    click_on "Back"
  end

  test "should destroy Profile" do
    visit profile_url(@profile)
    click_on "Destroy this profile", match: :first

    assert_text "Profile was successfully destroyed"
  end
end
