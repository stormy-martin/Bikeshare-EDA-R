# Explore Bikeshare Data
# Author: Stormy Martin
# Date: 06/29/2026
# Description: Exploratory analysis of bikeshare usage across Chicago, 
# New York City, and Washington DC using Jan-Jun 2017 Motivate dataset.

# Load Libraries
library(ggplot2)
library(dplyr)
library(tidyr)
library(lubridate)

ny = read.csv('new_york_city.csv')
chi = read.csv('chicago.csv')
wash = read.csv('washington.csv')

# Inspection
head(ny)
head(chi)
head(wash)

str(ny)
str(chi)
str(wash)

# DATA PREP FUNCTION
# Adds parsed time columns to any city dataframe.
# Used for all three cities to avoid repeating the same code.

data_prep <- function(df, city_name) {
  df$City       <- city_name
  df$Start.Time <- ymd_hms(df$Start.Time)   # parse datetime string
  df$Month      <- month(df$Start.Time, label = TRUE, abbr = TRUE)
  df$Weekday    <- wday(df$Start.Time,  label = TRUE, abbr = TRUE)
  df$Hour       <- hour(df$Start.Time)
  df$Day.Type <- ifelse(df$Weekday %in% c("Sat", "Sun"), "Weekend", "Weekday")
  df$Trip.Minutes <- df$Trip.Duration / 60   # convert seconds to minutes
  return(df)
}

# Apply function to all three cities
ny   <- data_prep(ny,   "New York City")
chi  <- data_prep(chi,  "Chicago")
wash <- data_prep(wash, "Washington")

# Combine into one dataframe for multi-city comparisons
all_cities <- bind_rows(ny, chi, wash)

# QUESTION 1
# Which hour of the day is busiest, and does this pattern
# differ between weekdays and weekends?

# Count trips grouped by hour and day type
hourly_counts <- all_cities %>%
  group_by(Hour, Day.Type) %>%
  summarise(Trips = n(), .groups = "drop")

# Bar chart of trips by hour, faceted by weekday vs weekend
ggplot(hourly_counts, aes(x = Hour, y = Trips, fill = Day.Type)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ Day.Type) +
  labs(
    title = "Hourly Bikeshare Trips by Day Type (Jan-Jun 2017)",
    x     = "Hour",
    y     = "Number of Trips"
  ) +
  
  theme_minimal()

# Q1 Summary Statistics - busiest hour for each day type
hourly_counts %>%
  group_by(Day.Type) %>%
  summarise(
    Busiest.Hour = Hour[which.max(Trips)],
    Max.Trips    = max(Trips)
  )


# QUESTION 2
# Do Subscribers or Customers dominate ridership, and does that split differ across cities?

# Count trips grouped by City and User Type
trip_counts <- all_cities %>%
  group_by(User.Type, City) %>%
  summarise(Trips = n(), .groups = "drop")

# Q2 Summary Statistics - User types based on city
trip_counts <- trip_counts %>%
  filter(User.Type %in% c("Subscriber", "Customer")) %>%
  group_by(City) %>%
  mutate(Percentage = round(Trips / sum(Trips) * 100, 1)) %>%
  ungroup()

# Bar chart of users by type and city
ggplot(trip_counts, aes(x = User.Type, y = Trips, fill = User.Type)) +
  geom_col(show.legend = TRUE) +
  facet_wrap(~ City) +
  labs(
    title = "Bikeshare Trips by User Type and City (Jan-Jun 2017)",
    x = "User Type",
    y = "Number of Trips",
    fill = "User Type"
  ) +
  
  theme_minimal() +
  theme(axis.text.x = element_blank())

# Print summary statistics with percentages by city
print(trip_counts)

# QUESTION 3
# Which city has the longest average trips, and how does trip duration vary across the full distribution?

# Filter out extreme outliers
all_cities_clean <- all_cities %>%
  filter(Trip.Minutes > 0 & Trip.Minutes <= 180)

# Q3 Summary Statistics - calculate mean, median and quartile trip duration by city
duration_stats <- all_cities_clean %>%
  group_by(City) %>%
  summarise(
    Mean.Minutes   = round(mean(Trip.Minutes), 1),
    Median.Minutes = round(median(Trip.Minutes), 1),
    Q1.Minutes     = round(quantile(Trip.Minutes, 0.25, na.rm = TRUE), 1),
    Q3.Minutes     = round(quantile(Trip.Minutes, 0.75, na.rm = TRUE), 1),
    Count          = n(),
    .groups        = "drop"
  )

# Print summary statistics
print(duration_stats)

# Box plot to show trip duration distribution by city
all_cities_clean %>%
  ggplot(aes(x = City, y = Trip.Minutes, fill = City)) +
  geom_boxplot(outlier.alpha = 0.1, show.legend = FALSE) +
  labs(
    title  = "Trip Duration by City (Jan-Jun 2017)",
    x      = "City",
    y      = "Trip Duration (Minutes)",
    fill   = "City"
  ) +
  theme_minimal()
