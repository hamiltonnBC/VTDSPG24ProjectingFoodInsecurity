# Virginia Tech Data Science for the Public Good 2024

## Overview
The Virginia Tech Data Science for the Public Good or VTDSPG is part of several DSPG programs in colleges and universities across the country. It promotes team science where undergraduate and graduate students work with faculty to address local and international social issues. The teams conduct research and experiential learning with statistics, computation, coding, and social sciences. Through this experience, the students gain experience in this project-focused program to present their findings to policy-makers, decision-makers, and the public.

## Project: Projecting Food Insecurity in Southwest Virginia

### Project Description
The aim of this project was to assist our stakeholder, Feeding Southwest Virginia, by providing a data-driven approach to food insecurity and give them necessary information to be utilized for their grant funding. We gathered socioeconomic data from the American Community Survey, Bureau of Labor Statistics, and the Current Population Survey for the years 2010-2022.

### Methodology
1. **Data Collection**: Socioeconomic data was gathered from multiple sources.
2. **Model Training**: We trained an XGBoost machine learning model on these state-level variables and then projected them to the county level.
3. **Projection**: We used an ARIMA model to project these variables into the future years up to 2027.
4. **Prediction**: With the trained XGBoost model, we predicted food insecurity rates for all counties through 2027.

### Findings
Our model had a very high level of accuracy and predicted a downward trend of food insecurity for all years, excluding COVID-19 related spikes. The details of these findings are displayed in an interactive web app.

## Repository Structure
- `Server`: Contains server-side logic.
- `ui`: Contains the user interface components.
- `global`: Includes global variables and functions.
- `app`: The main application file.
- `data`: Directory containing datasets.
- `www`: Directory containing images and other web resources.

## Team Members
- **Nicholas Hamilton**  
  [LinkedIn] (https://linkedin.com/in/nicholas-trey-hamilton)
- **Mia Jones**  
  [LinkedIn] (https://linkedin.com/in/mia-jones-mj48)
- **Emily Gard**  
  [LinkedIn] (https://linkedin.com/in/emilygard)

## Usage
To run the project, follow these steps:
1. Open the project in RStudio.
2. Load the required packages.
3. Run the `app.R` file.

```R
# Example to run the application
library(shiny)
runApp("path/to/your/app")