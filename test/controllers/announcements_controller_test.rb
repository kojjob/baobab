require "test_helper"

class AnnouncementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @announcement = announcements(:one)
  end

  test "should get index" do
    get announcements_url
    assert_response :success
  end

  test "should get new" do
    get new_announcement_url
    assert_response :success
  end

  test "should create announcement" do
    assert_difference("Announcement.count") do
      post announcements_url, params: { announcement: { action_url: @announcement.action_url, active: @announcement.active, announceable_id: @announcement.announceable_id, announceable_type: @announcement.announceable_type, clicks_count: @announcement.clicks_count, content: @announcement.content, domain: @announcement.domain, end_date: @announcement.end_date, icon: @announcement.icon, interaction_type: @announcement.interaction_type, location_constraint: @announcement.location_constraint, max_age: @announcement.max_age, metadata: @announcement.metadata, min_age: @announcement.min_age, partner_id: @announcement.partner_id, priority: @announcement.priority, start_date: @announcement.start_date, subtitle: @announcement.subtitle, title: @announcement.title, user_segment: @announcement.user_segment, views_count: @announcement.views_count, visibility: @announcement.visibility } }
    end

    assert_redirected_to announcement_url(Announcement.last)
  end

  test "should show announcement" do
    get announcement_url(@announcement)
    assert_response :success
  end

  test "should get edit" do
    get edit_announcement_url(@announcement)
    assert_response :success
  end

  test "should update announcement" do
    patch announcement_url(@announcement), params: { announcement: { action_url: @announcement.action_url, active: @announcement.active, announceable_id: @announcement.announceable_id, announceable_type: @announcement.announceable_type, clicks_count: @announcement.clicks_count, content: @announcement.content, domain: @announcement.domain, end_date: @announcement.end_date, icon: @announcement.icon, interaction_type: @announcement.interaction_type, location_constraint: @announcement.location_constraint, max_age: @announcement.max_age, metadata: @announcement.metadata, min_age: @announcement.min_age, partner_id: @announcement.partner_id, priority: @announcement.priority, start_date: @announcement.start_date, subtitle: @announcement.subtitle, title: @announcement.title, user_segment: @announcement.user_segment, views_count: @announcement.views_count, visibility: @announcement.visibility } }
    assert_redirected_to announcement_url(@announcement)
  end

  test "should destroy announcement" do
    assert_difference("Announcement.count", -1) do
      delete announcement_url(@announcement)
    end

    assert_redirected_to announcements_url
  end
end
