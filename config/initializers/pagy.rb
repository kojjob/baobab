
require "pagy/extras/bootstrap"

# Set up Pagy defaults
Pagy::DEFAULT[:items] = 15        # Items per page
Pagy::DEFAULT[:size]  = [ 1, 4, 4, 1 ] # Navigation size

# You can also customize other options
# Pagy::DEFAULT[:page_param] = :page    # Parameter name for page number
# Pagy::DEFAULT[:fragment] = true       # Add anchors to nav links
