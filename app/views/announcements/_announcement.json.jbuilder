json.extract! announcement, :id, :content, :title, :subtitle, :announceable_id, :announceable_type, :domain, :visibility, :interaction_type, :active, :start_date, :end_date, :action_url, :icon, :metadata, :priority, :views_count, :clicks_count, :location_constraint, :min_age, :max_age, :user_segment, :partner_id, :created_at, :updated_at
json.url announcement_url(announcement, format: :json)
