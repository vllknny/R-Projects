# Define the restaurant vector
restaurants <- c(
  "Big Bowl Noodle House", "Bistrozine", "Cafe Alina", "Carters Table",
  "El Jefes Taqueria", "Hibachi Express", "India Pavilioon", "Kokoro",
  "Mezeh", "Pimanti Bros.", "Roots Natural Kitchen", "Sowers Harvest Cafe",
  "The Waffle Shop", "Subway", "Mosul Grill", "Sip and Slurp",
  "Penn State Halal Guys", "Bubbas", "Tokyo Sushi and Hibachi", "Kokoro",
  "Dunkin", "Uncle Chens", "D.P. Dough", "Buffalo Wild Wings",
  "Tropical Smoothie Cafe", "Chipotle Mexican Grill", "Osaka",
  "Beijing Restaurant", "Playa Bowls"
)

# Define the Restaurant Sampler function
restaurant_sampler <- function(restaurant_list, n = 1) {
  sample(restaurant_list, size = n)
}

# Example usage
restaurant_sampler(restaurants, n = 1)
