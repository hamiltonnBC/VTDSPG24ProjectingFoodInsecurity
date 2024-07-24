# server.R
library(RColorBrewer)
library(leaflet.extras)
library(fontawesome)
function(input, output) {
  
# Main Tabs  
  output$overviewText <- renderText("This is the Overview page.")
  
  output$overview_image <- renderImage({
    list(src = "www/VTLOGO.jpeg",
         contentType = "image/jpeg",
         alt = "Overview Image")
  }, deleteFile = FALSE)

  # output$featureImportancePlot <- renderImage({
  #   list(src = "www/feature_importance_plotWithText.png",
  #        contentType = "image/png",
  #        alt = "Feature Importance Plot",
  #        width = "100%",
  #        height = "300px")
  # }, deleteFile = FALSE)
  
  output$swvaPredictedRatesMap <- renderImage({
    list(src = "www/swva_predicted_fi_rates_map_2010_2022_2027.png",
         contentType = "image/png",
         alt = "SWVA Predicted FI Rates Map",
         width = "100%",
         height = "400px")
  }, deleteFile = FALSE)
  
  # output$usMap <- renderImage({
  #   list(src = "www/US_Map.png",
  #        contentType = "image/png",
  #        alt = "US Map",
  #        width = "100%",
  #        height = "300px")
  # }, deleteFile = FALSE)
  
  output$fiRateHeatmap <- renderImage({
    list(src = "www/selectedenhanced_fi_rate_heatmap_selected_areasjul22.png",
         contentType = "image/png",
         alt = "FI Rate Heatmap",
         width = "100%",
         height = "400px")
  }, deleteFile = FALSE)
  
  #www/forecastDiagram.png
  
  # server.R

  # In server.R
  
  output$methodologyText <- renderUI({
    div(
      class = "methodology-text",
      h4("Methodology:"),
      p("Our approach uses XGBoost, a powerful machine learning technique, to predict food insecurity rates. We began by selecting variables related to food insecurity based on existing literature and Feeding America's Map the Meal Gap model. Our model includes all variables from Feeding America's model, except for disability rate due to inconsistent data at the county level, and incorporates additional factors for a more comprehensive analysis.")
    )
  })
  
  output$keySteps <- renderUI({
    div(
      class = "methodology-text",
      tags$ol(
        tags$li("Selecting relevant variables based on literature and existing models"),
        tags$li("Creating useful combinations of data through feature engineering"),
        tags$li("Preparing and structuring the data"),
        tags$li("Training and improving our XGBoost model"),
        tags$li("Validating model accuracy"),
        tags$li("Making county-level predictions"),
        tags$li("Forecasting future trends using ARIMA"),
        tags$li("Predicting future food insecurity rates up to 2027")
      )
    )
  })
  
  
  output$variableSelectionIntro <- renderUI({
    div(
      class = "methodology-text",
      h4("Variable Selection and Feature Engineering:"),
      p("We expanded on the Map the Meal Gap model by including:"),
      tags$ul(
        tags$li("Household vehicles available"),
        tags$li("Levels of educational attainment"),
        tags$li("Various alternate income sources (social security, food stamps rates, retirement income)"),
        tags$li("Detailed breakdown of age and income groups")
      ),
      p("We also created composite variables and interaction terms to capture complex relationships:")
    )
  })
  
  output$compositeVariables <- renderUI({
    div(
      class = "methodology-text",
      h6("Composite Variables:"),
      tags$ul(
        tags$li("Combined income categories for households with income under $35,000"),
        tags$li("Combined categories for individuals with a bachelor's degree or higher"),
        tags$li("Combined age categories for population 65 years and older and 19 years and under"),
        tags$li("Combined categories for individuals without a high school degree")
      )
    )
  })
  
  output$interactionTerms <- renderUI({
    div(
      class = "methodology-text",
      h6("Interaction Terms:"),
      tags$ul(
        tags$li("Retirement income percentage × Social Security income percentage"),
        tags$li("Cost per meal × various factors (home ownership rate, poverty rate, unemployment rate, Hispanic population percentage, Black population percentage)"),
        tags$li("Gender-specific population percentage × SNAP participation rate"),
        tags$li("Cost per meal × percentage of population 19 years and under"),
        tags$li("Cost per meal × percentage of households with income below $35,000")
      )
    )
  })
  
  output$dataPreparation <- renderUI({
    div(
      class = "methodology-text",
      h4("Data Preparation:"),
      tags$ol(
        tags$li("Combining regular data with engineered features"),
        tags$li("Converting Geographic Entity Identifiers (GEOID) and Year to factors"),
        tags$li("Creating dummy variables for GEOID and Year to account for fixed effects")
      )
    )
  })
  
  output$modelDevelopment <- renderUI({
    div(
      class = "methodology-text",
      h4("Model Development and Forecasting:"),
      p("We started with state-level data to train our XGBoost model, then applied our findings to make county-level predictions. To forecast future trends, we used ARIMA to predict how various social and economic factors might change in each county up to 2027. We then used these forecasted factors with our XGBoost model to predict food insecurity rates for each county through 2027."),
      p("Our model achieved a high level of accuracy in predicting food insecurity rates, providing a detailed picture of food insecurity across different areas. These forecasts offer valuable insights for long-term planning and proactive policy-making in addressing food insecurity.")
    )
  })
  # 
  # output$model1Box2Content <- renderUI({
  #   div(
  #     h4("Model Accuracy"),
  #     p("Our model achieved an accuracy rate of [Insert accuracy percentage]% in predicting food insecurity rates at the county level."),
  #     p("This high level of accuracy allows for confident use of the model in policy planning and resource allocation.")
  #   )
  # })
  # 
  # output$model1Box3Content <- renderUI({
  #   div(
  #     h4("Future Projections"),
  #     p("Based on our forecasts, we project that:"),
  #     tags$ul(
  #       tags$li("[X]% of counties may see an increase in food insecurity by 2027"),
  #       tags$li("[Y]% of counties may see a decrease in food insecurity by 2027"),
  #       tags$li("The average change in food insecurity rates across all counties is projected to be [Z]%")
  #     )
  #   )
  # })
  # # Comparative Model outputs
  # output$comparativeModelDescription <- renderUI({
  #   p("Below explains a simpler model we constructed mirroring Feeding America's Map the Meal Gap methodology as closely as possible.")
  # })
  # 
  # output$comparativeModelMethodology <- renderUI({
  #   p("We began this process by reading through Feeding America's Map the Meal Gap Technical Appendix, which explains how Feeding America 
  #     develops their food insecurity rates. We selected variables for the entire United States from the American Community Survey (ACS) and the 
  #     Bureau of Labor Statistics (BLS) that mimicked variables used in the Map the Meal Gap methodology. These included percent of Black households, 
  #     percent of Hispanic households, unemployment rate, poverty rate, median income, homeownership rate, and disability rate. While Feeding America 
  #     gathered most of these variables from the Current Population Survey (CPS), we used the equivalent ACS variables due to the complexity of gathering CPS data.")
  # })
  # 
  # output$comparativeModelMethodology2 <- renderUI({
  #   p("Using state and year fixed effects, we ran a regression at the state-level against the CPS food insecurity rate estimate. Next, we multiplied those 
  #     coefficients by the variables at the county-level to run a county-level regression. In this case, the state fixed effects were from the state that the 
  #     specific county is in. We then used an ARIMA statistical analysis model, which uses past trends and errors to create variables with stable means and variances. 
  #     It predicts future values of each variable at both the state and county-level. By taking those variable values at the county-level and multiplying them by the previously 
  #     developed county-level coefficients, we found our predicted future food insecurity rates.")
  # })
  # 
  # output$comparativeModelDifferences <- renderUI({
  #  p("This model only includes seven variables, despite there being additional factors that influence food insecurity rates.
  #     Our model includes many variables to provide a more detailed analysis. Additionally, the lack of variables in this model
  #    means that if one of the variables is not well predicted, it will have a larger impact on the overall results. By including more
  #    factors in our model, a singular factor being not as accurate will have a lesser impact on our predicted food insecurity rates.")
  # })
  # 
  # output$comparativeModelDataSources <- renderUI({
  #   tags$ul(
  #     tags$li("Data source 1: Description and link if applicable"),
  #     tags$li("Data source 2: Description and link if applicable")
  #   )
  # })
  # 
  # output$comparativeModelAdvantages <- renderUI({
  #   p("Discussion of the advantages of using this comparative model, such as...")
  # })
  # 
  # output$comparativeModelLimitations <- renderUI({
  #   p("Discussion of any limitations or assumptions in the Comparative Model, including...")
  # })
  # 
  #Accuracy outputs
  output$accuracyDescription <- renderUI({
    p("We tested the accuracy of our model to ensure it makes predictions that are as correct as possible.
    The graph below shows our predicted food insecurity rates versus the food insecurity rate estimates from the Current Population Survey.
    As displayed in the chart, we have above a 98% accuracy for all of the years at the state-level.
     ")
  })
  output$accuracyDescription2 <- renderUI({
    p("The graphs below show our predicted food insecurity rates (red dotted line) compared to the
   Current Population Survey food insecurity estimates (blue line) at the state-level.
     ")
  })
  

  #    To test the accuracy of our XGBoost model, we separated our data into a training set and a testing set.
  #The model used the training dataset to predict values in the testing dataset. This allowed us to select the most accurate XGBoost model based on
  #its predictions. We found that our chosen model can predict food insecurity rates at the state-level with 99% accuracy.   
  #At the county-level, we tested our accuracy by comparing the absolute value of our percent difference between our population weighted U.S. by county
  #year averages to the state averages year by year food insecurity rate. This comparison is depicted below.
  #output$resultsText <- renderText("This is the Results page.")
  #output$conclusionText <- renderText("This is the Conclusion page.")
  #output$referencesText <- renderText("This is the References page.")
  #output$meettheteamText <- renderText("This is the Meet the Team page.")

  # Data Tabs    
  output$allDataTable <- renderDataTable(allData, options = list(scrollX = TRUE))
  
  #forecasting tab ########################################################################################################################################################################################################
  
  output$countyImage <- renderImage({
    # Get the selected county
    selectedCounty <- input$countySelection
    
    # Split the selected county name into parts
    countyParts <- strsplit(selectedCounty, "_")[[1]]
    
    # Check if the county name contains "City"
    if ("City" %in% countyParts) {
      # If it's a city, combine the parts with "_" and add "_City" at the end
      countyName <- paste(c(countyParts[1], "City"), collapse = "_")
    } else {
      # If it's a county, combine the parts with "_" and add "_County" at the end
      countyName <- paste(c(countyParts, "County"), collapse = "_")
    }
    
    # Generate the file path based on the modified county name
    filePath <- paste0("www/FI_", countyName, ".png")
    
    # Check if the file exists
    if (file.exists(filePath)) {
      # Read the PNG file
      png(filePath)
      
      # Return the image
      list(src = filePath)
    } else {
      # Display a default image or a message if the file doesn't exist
      defaultImage <- "default.png"
      list(src = defaultImage)
    }
  }, deleteFile = FALSE)
  
  
  # Map Tabs

  #################### Map for Food Insecurity ##########################
  
  # Render the food insecurity map based on the selected year and checkboxes
  output$foodInsecurityMap <- renderLeaflet({
    year <- input$yearSelection
    CostPerMeal <- input$slider1  # Access the value of the slider
    
    # Filter the data for the current year
    SWVA_FI_year <- allData %>% filter(Year == year)
    
    SWVA_FI_year$Predicted_FI_Rate <- SWVA_FI_year$Predicted_FI_Rate * 100
    
    # Select the appropriate shapefile based on the year
    if (year <= 2013) {
      selected_counties <- counties2010[counties2010$GEOID %in% SWVA_FI_year$GEOID, ]
    } else {
      selected_counties <- counties2020[counties2020$GEOID %in% SWVA_FI_year$GEOID, ]
    }
    
    SWVA_FI_year$Predicted_FI_Rate <- round(SWVA_FI_year$Predicted_FI_Rate, 1)
    
    # Set the fixed color range for changes
    color_range <- c(2.5, 27)
    
    # Create a color palette with the fixed color range
    county_colors <- colorNumeric(palette = "YlOrRd", domain = color_range, reverse = FALSE)
    
    # Create the leaflet map for the current year
    map <- leaflet(selected_counties) %>%
      addTiles() %>%
      addPolygons(
        fillColor = ~county_colors(SWVA_FI_year$Predicted_FI_Rate[match(GEOID, SWVA_FI_year$GEOID)]),
        fillOpacity = 0.7,
        color = "white",
        weight = 1,
        popup = ~paste0(
          "<div style='font-family: Arial, sans-serif; font-size: 14px;'>",
          "<strong>", NAMELSAD, "</strong><br>",
          "<span style='color: #888;'>GEOID:</span> ", GEOID, "<br>",
          "<span style='color: #888;'> FI Rate:</span> ",
          "<span style='font-weight: bold; color: #007f00;'>",
          SWVA_FI_year$Predicted_FI_Rate[match(GEOID, SWVA_FI_year$GEOID)], "%",
          "</span>",
          "</div>"
        )
      )
    map <- map %>%
      addLegend(
        position = "bottomright",
        pal = county_colors,
        values = color_range,
        title = "Food Insecurity Rate (%) 2022",
        opacity = 0.7
      )
  })

  #Sidebar values
# SWVA
# Define the dynamic summary text based on the selected year
output$SWVA_mean_FI_Rate_Year <- renderText({
  Year <- input$yearSelection
  FI_Rate <- SWVA_total_per_year[SWVA_total_per_year$Year == Year, "FI_Rate"]
  
  if (length(FI_Rate) > 0) {
    # Format and display the FI Rate with a percentage sign
    paste("FI Rate:", FI_Rate, "%")
  } else {
    # Handle the case where the year is not found
    paste("No data available for the year", Year)
  }
})
output$SWVA_mean_POV_Year <- renderText({
  Year <- input$yearSelection
  POV <- SWVA_total_per_year[SWVA_total_per_year$Year == Year, "POV"]
  
  if (length(POV) > 0) {
    # Format and display the FI Rate with a percentage sign
    paste("Poverty Rate:", POV, "%")
  } else {
    # Handle the case where the year is not found
    paste("No data available for the year", Year)
  }
})
output$SWVA_mean_UN_Year <- renderText({
  Year <- input$yearSelection
  UN <- SWVA_total_per_year[SWVA_total_per_year$Year == Year, "UN"]
  
  if (length(UN) > 0) {
    # Format and display the FI Rate with a percentage sign
    paste("Unemployment Rate:", UN, "%")
  } else {
    # Handle the case where the year is not found
    paste("No data available for the year", Year)
  }
})

# All of VA
#Sidebar values
# Define the dynamic summary text based on the selected year
output$all_VA_mean_FI_Rate_Year <- renderText({
  Year <- input$yearSelection
  FI_Rate <- all_VA_total_per_year[all_VA_total_per_year$Year == Year, "FI_Rate"]
  
  if (length(FI_Rate) > 0) {
    # Format and display the FI Rate with a percentage sign
    paste("FI Rate:", FI_Rate, "%")
  } else {
    # Handle the case where the year is not found
    paste("No data available for the year", Year)
  }
})
output$all_VA_mean_POV_Year <- renderText({
  Year <- input$yearSelection
  POV <- all_VA_total_per_year[all_VA_total_per_year$Year == Year, "POV"]
  
  if (length(POV) > 0) {
    # Format and display the FI Rate with a percentage sign
    paste("Poverty Rate:", POV, "%")
  } else {
    # Handle the case where the year is not found
    paste("No data available for the year", Year)
  }
})
output$all_VA_mean_UN_Year <- renderText({
  Year <- input$yearSelection
  UN <- all_VA_total_per_year[all_VA_total_per_year$Year == Year, "UN"]
  
  if (length(UN) > 0) {
    # Format and display the FI Rate with a percentage sign
    paste("Unemployment Rate:", UN, "%")
  } else {
    # Handle the case where the year is not found
    paste("No data available for the year", Year)
  }
})

# United States
#Sidebar values
# Define the dynamic summary text based on the selected year
output$unitedStates_mean_FI_Rate_Year <- renderText({
  Year <- input$yearSelection
  FI_Rate <- unitedStates_total_per_year[unitedStates_total_per_year$Year == Year, "FI_Rate"]
  
  if (length(FI_Rate) > 0) {
    # Format and display the FI Rate with a percentage sign
    paste("FI Rate:", FI_Rate, "%")
  } else {
    # Handle the case where the year is not found
    paste("No data available for the year", Year)
  }
})
output$unitedStates_mean_POV_Year <- renderText({
  Year <- input$yearSelection
  POV <- unitedStates_total_per_year[unitedStates_total_per_year$Year == Year, "POV"]
  
  if (length(POV) > 0) {
    # Format and display the FI Rate with a percentage sign
    paste("Poverty Rate:", POV, "%")
  } else {
    # Handle the case where the year is not found
    paste("No data available for the year", Year)
  }
})
output$unitedStates_mean_UN_Year <- renderText({
  Year <- input$yearSelection
  UN <- unitedStates_total_per_year[unitedStates_total_per_year$Year == Year, "UN"]
  
  if (length(UN) > 0) {
    # Format and display the FI Rate with a percentage sign
    paste("Unemployment Rate:", UN, "%")
  } else {
    # Handle the case where the year is not found
    paste("No data available for the year", Year)
  }
})

# Appalachia
#Sidebar values
# Define the dynamic summary text based on the selected year
output$appalachia_mean_FI_Rate_Year <- renderText({
  Year <- input$yearSelection
  FI_Rate <- appalachia_total_per_year[appalachia_total_per_year$Year == Year, "FI_Rate"]
  
  if (length(FI_Rate) > 0) {
    # Format and display the FI Rate with a percentage sign
    paste("FI Rate:", FI_Rate, "%")
  } else {
    # Handle the case where the year is not found
    paste("No data available for the year", Year)
  }
})
output$appalachia_mean_POV_Year <- renderText({
  Year <- input$yearSelection
  POV <- appalachia_total_per_year[appalachia_total_per_year$Year == Year, "POV"]
  
  if (length(POV) > 0) {
    # Format and display the FI Rate with a percentage sign
    paste("Poverty Rate:", POV, "%")
  } else {
    # Handle the case where the year is not found
    paste("No data available for the year", Year)
  }
})
output$appalachia_mean_UN_Year <- renderText({
  Year <- input$yearSelection
  UN <- appalachia_total_per_year[appalachia_total_per_year$Year == Year, "UN"]
  
  if (length(UN) > 0) {
    # Format and display the FI Rate with a percentage sign
    paste("Unemployment Rate:", UN, "%")
  } else {
    # Handle the case where the year is not found
    paste("No data available for the year", Year)
  }
})
  #################### Map for food options map ##########################
  
  
  output$foodOptionsMap <- renderLeaflet({
    showFarmersMarkets <- input$fiMapFarmersMarketsCheckbox
    showGroceryStores <- input$fiMapGroceryStoresCheckbox
    showDollarStores <- input$fiMapDollarStoresCheckbox
    showFoodDistributors <- input$fiMapFoodDistributorsCheckbox
    
    # Filter the data for 2022
    SWVA_FI_2022 <- allData %>% filter(Year == 2022)
    
    SWVA_FI_2022$Predicted_FI_Rate <- SWVA_FI_2022$Predicted_FI_Rate * 100
    SWVA_FI_2022$Predicted_FI_Rate <- round(SWVA_FI_2022$Predicted_FI_Rate, digits = 1)
    
    # Select the appropriate shapefile (assuming you're using the 2020 counties for 2022 data)
    selected_counties <- counties2020[counties2020$GEOID %in% SWVA_FI_2022$GEOID, ]
    
    # Set the color range for changes (using the same range as in the food insecurity map)
    color_range <- c(2.5, 27)
    
    # Create a color palette
    county_colors <- colorNumeric(palette = "YlOrRd", domain = color_range, reverse = FALSE)
    
    # Create the base map with SWVA polygons
    map <- leaflet(selected_counties) %>%
      addTiles() %>%
      addPolygons(
        fillColor = ~county_colors(SWVA_FI_2022$Predicted_FI_Rate[match(GEOID, SWVA_FI_2022$GEOID)]),
        fillOpacity = 0.7,
        color = "white",
        weight = 1,
        popup = ~paste0(
          "<div style='font-family: Arial, sans-serif; font-size: 14px;'>",
          "<strong>", NAMELSAD, "</strong><br>",
          "<span style='color: #888;'>GEOID:</span> ", GEOID, "<br>",
          "<span style='color: #888;'>FI Rate (2022):</span> ",
          "<span style='font-weight: bold; color: #007f00;'>",
          SWVA_FI_2022$Predicted_FI_Rate[match(GEOID, SWVA_FI_2022$GEOID)], "%",
          "</span>",
          "</div>"
        )
      )
    
    # Add layers based on checkboxes
    if (showFarmersMarkets) {
      map <- map %>%
        addAwesomeMarkers(
          data = df_Farmers,
          lng = ~lon,
          lat = ~lat,
          popup = ~paste0(
            "<div style='font-family: Arial, sans-serif; font-size: 14px;'>",
            "<strong>", Business, "</strong><br>",
            "<span style='color: #888;'>Location:</span> ", Location, "<br>",
            "<span style='color: #888;'>SNAP/EBT:</span> ", SNAP_EBT, "<br>",
            "<span style='color: #888;'>WIC FMNP:</span> ", WIC_FMNP, "<br>",
            "<span style='color: #888;'>Senior FMNP:</span> ", Senior_FMNP, "<br>",
            "<span style='color: #888;'>VA Fresh Match:</span> ", VA_Fresh_Match, "<br>",
            "</div>"
          ),
          icon = awesomeIcons(
            icon = 'fa-location-pin',        
            markerColor = 'green',      
            iconColor = 'white'        
          ),
          group = "farmers_markets"
        )
    }
    
    if (showGroceryStores) {
      map <- map %>%
        addAwesomeMarkers(
          data = df_Grocery,
          lng = ~lon,
          lat = ~lat,
          popup = ~paste0(
            "<div style='font-family: Arial, sans-serif; font-size: 14px;'>",
            "<b>", Business, "</b><br>",
            "<span style='color: #888;'>County/City People per Grocery Store:</span> ", PeoplePerGrocery, "<br>",
            "<span style='color: #888;'>County/City Dollar to Grocery Store Ratio:</span> ", DollarToGroceryRatio, "<br>",
            "</div>"
          ),
          icon = awesomeIcons(
            icon = 'fa-location-pin',        
            markerColor = 'darkblue',      
            iconColor = 'white'        
          ),
          group = "grocery_stores"
        )
    }
    
    if (showDollarStores) {
      map <- map %>%
        addAwesomeMarkers(
          data = df_Dollar,
          lng = ~lon,
          lat = ~lat,
          popup = ~paste0(
            "<div style='font-family: Arial, sans-serif; font-size: 14px;'>",
            "<b>", Business, "</b><br>",
            "<span style='color: #888;'>County/City Dollar to Grocery Store Ratio:</span> ", DollarToGroceryRatio, "<br>",
            "</div>"
          ),
          icon = awesomeIcons(
            icon = 'fa-location-pin',        
            markerColor = 'orange',      
            iconColor = 'white'        
          ),
          group = "dollar_stores"
        )
    }
    
    if (showFoodDistributors) {
      map <- map %>%
        addAwesomeMarkers(
          data = df_Pantry,
          lng = ~lon,
          lat = ~lat,
          popup = ~paste0(
            "<div style='font-family: Arial, sans-serif; font-size: 14px;'>",
            "<b>", Business, "</b><br>",
            "<span style='color: #888;'>Location:</span> ", Location, "<br>",
            "</div>"
          ),
          icon = awesomeIcons(
            icon = 'fa-location-pin',        
            markerColor = 'purple',      
            iconColor = 'white'        
          ),
          group = "food_distributors"
        )
    }
    
    # Add a legend
    map <- map %>%
      addLegend(
        position = "bottomright",
        pal = county_colors,
        values = c(10, 20),
        title = "Food Insecurity Rate (%) 2022",
        opacity = 0.7
      )
    
    map
  })
  
  #################### Map for changes in Food Insecurity ##########################
  

  
  
  
  output$foodInsecurityChanges <- renderLeaflet({
    year1 <- as.integer(input$year1)
    year2 <- as.integer(input$year2)
    
    # Select appropriate shapefiles based on the years
    if (year1 <= 2013) {
      counties1 <- counties2010
    } else {
      counties1 <- counties2020
    }
    
    if (year2 <= 2013) {
      counties2 <- counties2010
    } else {
      counties2 <- counties2020
    }
    
    data1 <- allData %>% filter(Year == year1)
    data2 <- allData %>% filter(Year == year2)
    
    data1$Predicted_FI_Rate <- data1$Predicted_FI_Rate * 100
    data2$Predicted_FI_Rate <- data2$Predicted_FI_Rate * 100
    
    selected_counties1 <- counties1[counties1$GEOID %in% data1$GEOID, ]
    selected_counties2 <- counties2[counties2$GEOID %in% data2$GEOID, ]
    
    # Calculate the change in FI_Rate
    data2$FI_Rate_Change <- data2$Predicted_FI_Rate - data1$Predicted_FI_Rate[match(data2$GEOID, data1$GEOID)]
    
    # Round this change to one decimal point
    data2$FI_Rate_Change <- round(data2$FI_Rate_Change, 1)
    
    # Calculate the dynamic color range
    color_range <- range(data2$FI_Rate_Change, na.rm = TRUE)
    
    county_colors <- colorNumeric(palette = "PRGn", domain = color_range, reverse = TRUE)
    
    leaflet(selected_counties2) %>%
      addTiles() %>%
      addPolygons(
        fillColor = ~county_colors(data2$FI_Rate_Change[match(GEOID, data2$GEOID)]),
        fillOpacity = 0.8,
        color = "white",
        weight = 1,
        popup = ~paste0(
          "<div style='font-family: Arial, sans-serif; font-size: 14px;'>",
          "<strong>", NAMELSAD, "</strong><br>",
          "<span style='color: #888;'>GEOID:</span> ", GEOID, "<br>",
          "<span style='color: #888;'>FI Rate Change:</span> ",
          #"<span style='font-weight: bold; color: #007f00;'>",
          data2$FI_Rate_Change[match(GEOID, data2$GEOID)], "%",
          "</span>",
          "</div>"
        )
      ) %>%
      addLegend(
        pal = county_colors,
        values = data2$FI_Rate_Change,
        title = paste("FI Rate Change (%):", year1, "-", year2)
      )
  })
  
  
  
  ####### By County Forecasted FI Plotly ########################################################################################################################################################################################################
  
  # Reorder the levels of the Name factor
  SWVA_Plotly$Name <- factor(SWVA_Plotly$Name, levels = c(setdiff(unique(SWVA_Plotly$Name), "SWVA Total"), "SWVA Total"))
  
  # Create the ggplot
  ggplot_obj <- ggplot(SWVA_Plotly, aes(x = Year, y = FI_Rate, color = Type)) +
    geom_line() +
    geom_point(data = SWVA_Plotly %>% distinct(Name, Year, .keep_all = TRUE), size = 3) +
    facet_wrap(~ Name, scales = "free_y") +
    labs(title = "Comparison of Actual and Forecasted Food Insecurity Rates by County and SWVA Total",
         x = "Year", y = "Food Insecurity Rate") +
    theme_minimal() +
    theme(legend.position = "bottom")

  # Convert the ggplot to an interactive plotly object
  plotly_obj <- ggplotly(ggplot_obj)

  # Render the plotly object
  output$plotly <- renderPlotly({
    plotly_obj
  })

}