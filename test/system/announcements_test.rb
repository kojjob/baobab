require "application_system_test_case"

class AnnouncementsTest < ApplicationSystemTestCase
  setup do
    @announcement = announcements(:one)
  end

  test "visiting the index" do
    visit announcements_url
    assert_selector "h1", text: "Announcements"
  end

  test "should create announcement" do
    visit announcements_url
    click_on "New announcement"

    fill_in "Action url", with: @announcement.action_url
    check "Active" if @announcement.active
    fill_in "Announceable", with: @announcement.announceable_id
    fill_in "Announceable type", with: @announcement.announceable_type
    fill_in "Clicks count", with: @announcement.clicks_count
    fill_in "Content", with: @announcement.content
    fill_in "Domain", with: @announcement.domain
    fill_in "End date", with: @announcement.end_date
    fill_in "Icon", with: @announcement.icon
    fill_in "Interaction type", with: @announcement.interaction_type
    fill_in "Location constraint", with: @announcement.location_constraint
    fill_in "Max age", with: @announcement.max_age
    fill_in "Metadata", with: @announcement.metadata
    fill_in "Min age", with: @announcement.min_age
    fill_in "Partner", with: @announcement.partner_id
    fill_in "Priority", with: @announcement.priority
    fill_in "Start date", with: @announcement.start_date
    fill_in "Subtitle", with: @announcement.subtitle
    fill_in "Title", with: @announcement.title
    fill_in "User segment", with: @announcement.user_segment
    fill_in "Views count", with: @announcement.views_count
    fill_in "Visibility", with: @announcement.visibility
    click_on "Create Announcement"

    assert_text "Announcement was successfully created"
    click_on "Back"
  end

  test "should update Announcement" do
    visit announcement_url(@announcement)
    click_on "Edit this announcement", match: :first

    fill_in "Action url", with: @announcement.action_url
    check "Active" if @announcement.active
    fill_in "Announceable", with: @announcement.announceable_id
    fill_in "Announceable type", with: @announcement.announceable_type
    fill_in "Clicks count", with: @announcement.clicks_count
    fill_in "Content", with: @announcement.content
    fill_in "Domain", with: @announcement.domain
    fill_in "End date", with: @announcement.end_date.to_s
    fill_in "Icon", with: @announcement.icon
    fill_in "Interaction type", with: @announcement.interaction_type
    fill_in "Location constraint", with: @announcement.location_constraint
    fill_in "Max age", with: @announcement.max_age
    fill_in "Metadata", with: @announcement.metadata
    fill_in "Min age", with: @announcement.min_age
    fill_in "Partner", with: @announcement.partner_id
    fill_in "Priority", with: @announcement.priority
    fill_in "Start date", with: @announcement.start_date.to_s
    fill_in "Subtitle", with: @announcement.subtitle
    fill_in "Title", with: @announcement.title
    fill_in "User segment", with: @announcement.user_segment
    fill_in "Views count", with: @announcement.views_count
    fill_in "Visibility", with: @announcement.visibility
    click_on "Update Announcement"

    assert_text "Announcement was successfully updated"
    click_on "Back"
  end

  test "should destroy Announcement" do
    visit announcement_url(@announcement)
    click_on "Destroy this announcement", match: :first

    assert_text "Announcement was successfully destroyed"
  end
end
