# Zurich Traffic Accident Dashboard

https://oag11z-frikki94.shinyapps.io/roadaccidents/

This project is an interactive dashboard analyzing traffic accidents in Zurich. Built with **Quarto** and **Shiny components**, it allows users to explore traffic accident data dynamically, offering interactive filters, maps, and visualizations.

---

## Data Source

The dataset is sourced from the [Open Data Swiss portal](https://opendata.swiss/en/dataset/strassenverkehrsunfalle-mit-personenschaden), which provides detailed records of road traffic accidents involving personal injuries.

---

## Project Structure

To optimize performance and interactivity, the project is divided into two main components:

1. **Data Wrangling (`Datawrangling.R`)**
   - Pre-processes the raw dataset:
    - Data cleaning and filtering.
    - Reverse geocoding using the Google API (with unexpected costs 😬)
    - Saves a processed dataset locally to avoid redundant API calls and high loading times.

2. **Dashboard (`roadaccidents2.qmd`)**
   - A Quarto document enhanced with Shiny components to enable interactivity.
   - Loads the pre-processed data and renders:
   - A Leaflet-based map for visualizing accident locations.
   - Plotly-based plots for accident trends.
   - Shiny widgets for dynamic filtering (e.g., dropdowns, sliders).
   - Allows users to:
     - Explore where most accidents occur within their postcode.
     - Identify streets where accidents happen most frequently.
     - Analyze specific types of accidents (e.g., bike-related accidents) in their postcode.

---

## Tools and Technologies

- **Quarto**: Document-based dashboard framework.
- **Shiny**: Interactive components for dynamic user interfaces.
- **Leaflet**: Maps for visualizing accident locations.
- **Plotly**: Interactive plots and graphs.
- **Google API**: Reverse geocoding to map coordinates to addresses.

---
