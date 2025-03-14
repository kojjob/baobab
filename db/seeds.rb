# db/seeds.rb - Category seeding

# Clear existing categories to avoid duplicates
puts "Clearing existing categories..."
Category.destroy_all

# Create blog categories
categories = [
  {
    name: "Financial Literacy",
    slug: "financial-literacy",
    description: "Tips and resources for managing money, understanding mobile banking, and building financial stability in Ghana."
  },
  {
    name: "Technology",
    slug: "technology",
    description: "Insights on digital trends, app features, and tech innovations shaping Ghana's digital landscape."
  },
  {
    name: "Business & Entrepreneurship",
    slug: "business-entrepreneurship",
    description: "Resources for small business owners, market vendors, and aspiring entrepreneurs in Ghana."
  },
  {
    name: "Food & Cuisine",
    slug: "food-cuisine",
    description: "Explorations of Ghanaian dishes, recipes, restaurant reviews, and food delivery tips."
  },
  {
    name: "Transportation",
    slug: "transportation",
    description: "Updates on ride-sharing, public transit, and tips for navigating transportation in Ghanaian cities."
  },
  {
    name: "Community Stories",
    slug: "community-stories",
    description: "Personal experiences, success stories, and community highlights from Supper Ghana users."
  },
  {
    name: "Health & Wellness",
    slug: "health-wellness",
    description: "Information on healthcare services, wellness tips, and maintaining good health in Ghana."
  },
  {
    name: "Agriculture",
    slug: "agriculture",
    description: "Resources for farmers, agricultural market trends, and innovations in Ghana's farming sector."
  },
  {
    name: "Education",
    slug: "education",
    description: "Learning resources, school information, and educational opportunities across Ghana."
  },
  {
    name: "Travel & Tourism",
    slug: "travel-tourism",
    description: "Guides to local destinations, travel tips, and highlights of Ghana's cultural and natural attractions."
  },
  {
    name: "Events & Entertainment",
    slug: "events-entertainment",
    description: "Updates on local events, entertainment options, and cultural activities throughout Ghana."
  },
  {
    name: "App Updates",
    slug: "app-updates",
    description: "Official announcements, new features, and updates about the Supper Ghana platform."
  }
]

# Create each category
puts "Creating categories..."
categories.each do |category_attrs|
  category = Category.create!(category_attrs)
  puts "Created category: #{category.name}"
end

puts "Created #{Category.count} categories successfully!"

# Create some popular tags
puts "Creating tags..."
tags = [
  { name: "Mobile Money", slug: "mobile-money" },
  { name: "Tips & Tricks", slug: "tips-tricks" },
  { name: "Getting Started", slug: "getting-started" },
  { name: "Success Story", slug: "success-story" },
  { name: "How-to Guide", slug: "how-to-guide" },
  { name: "Market Trends", slug: "market-trends" },
  { name: "Small Business", slug: "small-business" },
  { name: "Accra", slug: "accra" },
  { name: "Kumasi", slug: "kumasi" },
  { name: "Rural Communities", slug: "rural-communities" },
  { name: "Feature Spotlight", slug: "feature-spotlight" },
  { name: "User Experience", slug: "user-experience" },
  { name: "Digital Literacy", slug: "digital-literacy" },
  { name: "Community Support", slug: "community-support" },
  { name: "Savings", slug: "savings" }
]

tags.each do |tag_attrs|
  tag = Tag.create!(tag_attrs)
  puts "Created tag: #{tag.name}"
end

puts "Created #{Tag.count} tags successfully!"
puts "Seed data creation completed!"
