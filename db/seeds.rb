# Clear existing categories to prevent duplicates
# Comment this out if you want to preserve existing data
# Category.destroy_all

# Helper method to create or find a category
def create_or_find_category(attributes)
  Category.find_or_create_by(slug: attributes[:slug]) do |category|
    category.name = attributes[:name]
    category.description = attributes[:description]
    category.icon = attributes[:icon]
    category.position = attributes[:position]
    category.featured = attributes[:featured] || false
    category.active = attributes[:active] || true
    category.parent = attributes[:parent] if attributes[:parent]
  end
end

# ------------------------------------
# UNCATEGORIZED
# ------------------------------------
create_or_find_category(
  name: "Uncategorized",
  slug: "uncategorized",
  description: "Miscellaneous items",
  position: 999,
  featured: false,
  active: true
)

# ------------------------------------
# ELECTRONICS
# ------------------------------------
electronics = create_or_find_category(
  name: "Electronics",
  slug: "electronics",
  description: "Phones, computers, and electronic devices",
  icon: "fas fa-tv",
  position: 1,
  featured: true,
  active: true
)

create_or_find_category(
  name: "Smartphones",
  slug: "smartphones",
  description: "Mobile phones and accessories",
  icon: "fas fa-mobile-alt",
  parent: electronics,
  position: 1,
  featured: true,
  active: true
)

create_or_find_category(
  name: "Android Phones",
  slug: "android-phones",
  description: "Samsung, Tecno, Infinix, and other Android devices",
  icon: "fab fa-android",
  parent: electronics.subcategories.find_by(slug: "smartphones"),
  position: 1,
  active: true
)

create_or_find_category(
  name: "iPhones",
  slug: "iphones",
  description: "Apple iPhone devices",
  icon: "fab fa-apple",
  parent: electronics.subcategories.find_by(slug: "smartphones"),
  position: 2,
  active: true
)

create_or_find_category(
  name: "Phone Accessories",
  slug: "phone-accessories",
  description: "Cases, screen protectors, and chargers",
  icon: "fas fa-plug",
  parent: electronics.subcategories.find_by(slug: "smartphones"),
  position: 3,
  active: true
)

# Electronics - Computers
computers = create_or_find_category(
  name: "Computers",
  slug: "computers",
  description: "Laptops, desktops, and accessories",
  icon: "fas fa-laptop",
  parent: electronics,
  position: 2,
  active: true
)

create_or_find_category(
  name: "Laptops",
  slug: "laptops",
  description: "Portable computers from all brands",
  icon: "fas fa-laptop",
  parent: computers,
  position: 1,
  active: true
)

create_or_find_category(
  name: "Desktops",
  slug: "desktops",
  description: "Desktop computers and workstations",
  icon: "fas fa-desktop",
  parent: computers,
  position: 2,
  active: true
)

create_or_find_category(
  name: "Computer Accessories",
  slug: "computer-accessories",
  description: "Keyboards, mice, and other peripherals",
  icon: "fas fa-keyboard",
  parent: computers,
  position: 3,
  active: true
)

# Electronics - Home Electronics
home_electronics = create_or_find_category(
  name: "Home Electronics",
  slug: "home-electronics",
  description: "TVs, sound systems, and home appliances",
  icon: "fas fa-home",
  parent: electronics,
  position: 3,
  active: true
)

create_or_find_category(
  name: "Televisions",
  slug: "televisions",
  description: "Smart TVs and traditional televisions",
  icon: "fas fa-tv",
  parent: home_electronics,
  position: 1,
  active: true
)

create_or_find_category(
  name: "Audio Systems",
  slug: "audio-systems",
  description: "Speakers, sound systems, and audio equipment",
  icon: "fas fa-volume-up",
  parent: home_electronics,
  position: 2,
  active: true
)

# ------------------------------------
# FASHION
# ------------------------------------
fashion = create_or_find_category(
  name: "Fashion",
  slug: "fashion",
  description: "Clothing, shoes, and accessories",
  icon: "fas fa-tshirt",
  position: 2,
  featured: true,
  active: true
)

# Fashion - Men's Clothing
mens_clothing = create_or_find_category(
  name: "Men's Clothing",
  slug: "mens-clothing",
  description: "Shirts, trousers, and outerwear for men",
  icon: "fas fa-male",
  parent: fashion,
  position: 1,
  active: true
)

create_or_find_category(
  name: "Men's Shirts",
  slug: "mens-shirts",
  description: "T-shirts, dress shirts, and casual tops",
  icon: "fas fa-tshirt",
  parent: mens_clothing,
  position: 1,
  active: true
)

create_or_find_category(
  name: "Men's Trousers",
  slug: "mens-trousers",
  description: "Pants, jeans, and shorts",
  icon: "fas fa-socks",
  parent: mens_clothing,
  position: 2,
  active: true
)

create_or_find_category(
  name: "Men's Traditional Wear",
  slug: "mens-traditional-wear",
  description: "Kente cloth and traditional Ghanaian attire",
  icon: "fas fa-user-tie",
  parent: mens_clothing,
  position: 3,
  active: true
)

# Fashion - Women's Clothing
womens_clothing = create_or_find_category(
  name: "Women's Clothing",
  slug: "womens-clothing",
  description: "Dresses, tops, and outerwear for women",
  icon: "fas fa-female",
  parent: fashion,
  position: 2,
  active: true
)

create_or_find_category(
  name: "Women's Dresses",
  slug: "womens-dresses",
  description: "Casual and formal dresses",
  icon: "fas fa-female",
  parent: womens_clothing,
  position: 1,
  active: true
)

create_or_find_category(
  name: "Women's Tops",
  slug: "womens-tops",
  description: "Blouses, t-shirts, and casual tops",
  icon: "fas fa-tshirt",
  parent: womens_clothing,
  position: 2,
  active: true
)

create_or_find_category(
  name: "Women's Traditional Wear",
  slug: "womens-traditional-wear",
  description: "Kente cloth and traditional Ghanaian attire",
  icon: "fas fa-user-tie",
  parent: womens_clothing,
  position: 3,
  active: true
)

# Fashion - Footwear
footwear = create_or_find_category(
  name: "Footwear",
  slug: "footwear",
  description: "Shoes, sandals, and footwear for all",
  icon: "fas fa-shoe-prints",
  parent: fashion,
  position: 3,
  active: true
)

create_or_find_category(
  name: "Men's Shoes",
  slug: "mens-shoes",
  description: "Formal shoes, sneakers, and sandals for men",
  icon: "fas fa-shoe-prints",
  parent: footwear,
  position: 1,
  active: true
)

create_or_find_category(
  name: "Women's Shoes",
  slug: "womens-shoes",
  description: "Heels, flats, and sandals for women",
  icon: "fas fa-shoe-prints",
  parent: footwear,
  position: 2,
  active: true
)

create_or_find_category(
  name: "Children's Shoes",
  slug: "childrens-shoes",
  description: "Footwear for kids and infants",
  icon: "fas fa-child",
  parent: footwear,
  position: 3,
  active: true
)

# ------------------------------------
# FOOD & GROCERIES
# ------------------------------------
food_groceries = create_or_find_category(
  name: "Food & Groceries",
  slug: "food-groceries",
  description: "Fresh food, groceries, and household items",
  icon: "fas fa-shopping-basket",
  position: 3,
  featured: true,
  active: true
)

create_or_find_category(
  name: "Fresh Produce",
  slug: "fresh-produce",
  description: "Fruits, vegetables, and fresh farm products",
  icon: "fas fa-apple-alt",
  parent: food_groceries,
  position: 1,
  active: true
)

create_or_find_category(
  name: "Meat & Fish",
  slug: "meat-fish",
  description: "Fresh and frozen meat and seafood",
  icon: "fas fa-fish",
  parent: food_groceries,
  position: 2,
  active: true
)

create_or_find_category(
  name: "Grains & Staples",
  slug: "grains-staples",
  description: "Rice, maize, millet, and other staples",
  icon: "fas fa-seedling",
  parent: food_groceries,
  position: 3,
  active: true
)

create_or_find_category(
  name: "Packaged Foods",
  slug: "packaged-foods",
  description: "Canned goods, snacks, and ready-to-eat items",
  icon: "fas fa-box-open",
  parent: food_groceries,
  position: 4,
  active: true
)

# ------------------------------------
# HOME & KITCHEN
# ------------------------------------
home_kitchen = create_or_find_category(
  name: "Home & Kitchen",
  slug: "home-kitchen",
  description: "Furniture, decor, and kitchen essentials",
  icon: "fas fa-home",
  position: 4,
  featured: true,
  active: true
)

create_or_find_category(
  name: "Furniture",
  slug: "furniture",
  description: "Tables, chairs, beds, and home furnishings",
  icon: "fas fa-couch",
  parent: home_kitchen,
  position: 1,
  active: true
)

create_or_find_category(
  name: "Kitchen & Dining",
  slug: "kitchen-dining",
  description: "Cookware, utensils, and dining essentials",
  icon: "fas fa-utensils",
  parent: home_kitchen,
  position: 2,
  active: true
)

create_or_find_category(
  name: "Home Decor",
  slug: "home-decor",
  description: "Decorative items for your home",
  icon: "fas fa-paint-roller",
  parent: home_kitchen,
  position: 3,
  active: true
)

create_or_find_category(
  name: "Bedding & Bath",
  slug: "bedding-bath",
  description: "Linens, towels, and bathroom essentials",
  icon: "fas fa-bed",
  parent: home_kitchen,
  position: 4,
  active: true
)

# ------------------------------------
# BEAUTY & HEALTH
# ------------------------------------
beauty_health = create_or_find_category(
  name: "Beauty & Health",
  slug: "beauty-health",
  description: "Personal care, cosmetics, and health products",
  icon: "fas fa-heartbeat",
  position: 5,
  featured: true,
  active: true
)

create_or_find_category(
  name: "Skincare",
  slug: "skincare",
  description: "Facial care, body care, and skin treatments",
  icon: "fas fa-spa",
  parent: beauty_health,
  position: 1,
  active: true
)

create_or_find_category(
  name: "Haircare",
  slug: "haircare",
  description: "Shampoo, conditioner, and hair treatments",
  icon: "fas fa-cut",
  parent: beauty_health,
  position: 2,
  active: true
)

create_or_find_category(
  name: "Makeup",
  slug: "makeup",
  description: "Cosmetics and beauty tools",
  icon: "fas fa-paint-brush",
  parent: beauty_health,
  position: 3,
  active: true
)

create_or_find_category(
  name: "Personal Hygiene",
  slug: "personal-hygiene",
  description: "Bath, oral care, and personal hygiene products",
  icon: "fas fa-shower",
  parent: beauty_health,
  position: 4,
  active: true
)

create_or_find_category(
  name: "Health & Wellness",
  slug: "health-wellness",
  description: "Vitamins, supplements, and wellness products",
  icon: "fas fa-heartbeat",
  parent: beauty_health,
  position: 5,
  active: true
)

# ------------------------------------
# MOBILE SERVICES
# ------------------------------------
mobile_services = create_or_find_category(
  name: "Mobile Services",
  slug: "mobile-services",
  description: "Airtime, data, and mobile financial services",
  icon: "fas fa-mobile",
  position: 6,
  featured: true,
  active: true
)

create_or_find_category(
  name: "Airtime & Data",
  slug: "airtime-data",
  description: "Mobile phone airtime and internet bundles",
  icon: "fas fa-wifi",
  parent: mobile_services,
  position: 1,
  active: true
)

create_or_find_category(
  name: "Bill Payments",
  slug: "bill-payments",
  description: "Utility bills and subscription payments",
  icon: "fas fa-file-invoice",
  parent: mobile_services,
  position: 2,
  active: true
)

create_or_find_category(
  name: "Mobile Money",
  slug: "mobile-money",
  description: "Mobile financial services and transfers",
  icon: "fas fa-money-bill-wave",
  parent: mobile_services,
  position: 3,
  active: true
)

# ------------------------------------
# AGRICULTURE
# ------------------------------------
agriculture = create_or_find_category(
  name: "Agriculture",
  slug: "agriculture",
  description: "Farming supplies, seeds, and equipment",
  icon: "fas fa-tractor",
  position: 7,
  featured: false,
  active: true
)

create_or_find_category(
  name: "Seeds & Plants",
  slug: "seeds-plants",
  description: "Seeds, seedlings, and planting materials",
  icon: "fas fa-seedling",
  parent: agriculture,
  position: 1,
  active: true
)

create_or_find_category(
  name: "Fertilizers",
  slug: "fertilizers",
  description: "Plant nutrients and soil amendments",
  icon: "fas fa-prescription-bottle",
  parent: agriculture,
  position: 2,
  active: true
)

create_or_find_category(
  name: "Farm Tools",
  slug: "farm-tools",
  description: "Agricultural implements and tools",
  icon: "fas fa-tools",
  parent: agriculture,
  position: 3,
  active: true
)

create_or_find_category(
  name: "Livestock Supplies",
  slug: "livestock-supplies",
  description: "Feed, health products, and supplies for animals",
  icon: "fas fa-drumstick-bite",
  parent: agriculture,
  position: 4,
  active: true
)

# ------------------------------------
# BOOKS & STATIONERY
# ------------------------------------
books_stationery = create_or_find_category(
  name: "Books & Stationery",
  slug: "books-stationery",
  description: "Books, educational materials, and office supplies",
  icon: "fas fa-book",
  position: 8,
  featured: false,
  active: true
)

create_or_find_category(
  name: "Books",
  slug: "books",
  description: "Fiction, non-fiction, and textbooks",
  icon: "fas fa-book-open",
  parent: books_stationery,
  position: 1,
  active: true
)

create_or_find_category(
  name: "School Supplies",
  slug: "school-supplies",
  description: "Notebooks, pens, and educational materials",
  icon: "fas fa-pen",
  parent: books_stationery,
  position: 2,
  active: true
)

create_or_find_category(
  name: "Office Supplies",
  slug: "office-supplies",
  description: "Business and office stationery",
  icon: "fas fa-paperclip",
  parent: books_stationery,
  position: 3,
  active: true
)

# ------------------------------------
# SERVICES
# ------------------------------------
services = create_or_find_category(
  name: "Services",
  slug: "services",
  description: "Professional and personal services",
  icon: "fas fa-concierge-bell",
  position: 9,
  featured: false,
  active: true
)

create_or_find_category(
  name: "Transportation",
  slug: "transportation",
  description: "Ride services, delivery, and transport",
  icon: "fas fa-car",
  parent: services,
  position: 1,
  active: true
)

create_or_find_category(
  name: "Home Services",
  slug: "home-services",
  description: "Cleaning, repairs, and household assistance",
  icon: "fas fa-broom",
  parent: services,
  position: 2,
  active: true
)

create_or_find_category(
  name: "Professional Services",
  slug: "professional-services",
  description: "Consulting, legal, and business services",
  icon: "fas fa-briefcase",
  parent: services,
  position: 3,
  active: true
)

create_or_find_category(
  name: "Education & Tutoring",
  slug: "education-tutoring",
  description: "Classes, courses, and educational services",
  icon: "fas fa-graduation-cap",
  parent: services,
  position: 4,
  active: true
)

# ------------------------------------
# ARTS & CRAFTS
# ------------------------------------
arts_crafts = create_or_find_category(
  name: "Arts & Crafts",
  slug: "arts-crafts",
  description: "Handmade items, art supplies, and traditional crafts",
  icon: "fas fa-paint-brush",
  position: 10,
  featured: false,
  active: true
)

create_or_find_category(
  name: "Traditional Crafts",
  slug: "traditional-crafts",
  description: "Kente cloth, beads, and traditional Ghanaian crafts",
  icon: "fas fa-palette",
  parent: arts_crafts,
  position: 1,
  active: true
)

create_or_find_category(
  name: "Art Supplies",
  slug: "art-supplies",
  description: "Paints, canvases, and artistic materials",
  icon: "fas fa-pencil-alt",
  parent: arts_crafts,
  position: 2,
  active: true
)

create_or_find_category(
  name: "Handmade Items",
  slug: "handmade-items",
  description: "Unique handcrafted goods and gifts",
  icon: "fas fa-hands",
  parent: arts_crafts,
  position: 3,
  active: true
)

# Output summary
puts "Created #{Category.count} categories:"
puts "- #{Category.where(parent_id: nil).count} main categories"
puts "- #{Category.where.not(parent_id: nil).count} subcategories"
puts "- #{Category.where(featured: true).count} featured categories"
puts "- #{Category.where(active: true).count} active categories"
