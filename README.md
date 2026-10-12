# Bikeshare Data Analysis

## Overview
Exploratory analysis of bikeshare usage patterns across Chicago, New York City, 
and Washington DC using Jan-Jun 2017 data from Motivate.

## Questions Explored
1. Which hour of the day is busiest, and does this pattern differ between weekdays and weekends?
2. Do Subscribers or Customers dominate ridership, and does that split differ across cities?
3. Which city has the longest average trips, and how does trip duration vary across the full distribution?

## Key Findings
1. **Commuting drives weekday demand.** Weekday trips peak around 8 AM and 5 PM; weekend trips peak around noon. The 8 AM weekday peak (13,147 trips) is more than three times the weekend noon peak (3,679).
2. **Subscribers dominate in every city:** 89.8% in New York City, 79.8% in Chicago, and 73.7% in Washington DC. Washington's higher share of pay-per-ride customers likely reflects more visitors.
3. **Washington has the longest trips:** 17.9-minute average (11.7-minute median), with a wider spread (IQR 6.8–20.3 minutes) than New York (6.1–17.4).

## Tools Used
- R
- ggplot2, dplyr, lubridate, tidyr
