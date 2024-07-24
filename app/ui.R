library(shiny)
library(shiny.semantic)
library(semantic.dashboard)
library(plotly)
library(DT)
library(glmnet)
library(ggplot2)
library(gridExtra)
library(leaflet.extras)
library(fontawesome)

ui <- dashboardPage(
  margin = TRUE,
  dashboardHeader(
    color = "gray",
    title = "Virginia Tech Data Science For The Public Good - Projecting Food Insecurity",
    inverted = TRUE,
    titleWidth = "very wide",
    show_menu_button = TRUE
  ),
  dashboardSidebar(
    side = "left",
    size = "thin",
    color = "teal",
    overlay = FALSE,
    pushable = TRUE,
    visible = TRUE,
    dim_page = FALSE,
    closable = FALSE,
    sidebarMenu(
      menuItem(tabName = "overview", text = "Overview", icon = icon("home")),
      menuItem(tabName = "background", text = "Background", icon = icon("info")),
      menuItem(tabName = "methodology", text = "Methodology", icon = icon("cogs")),
      menuItem(tabName = "map", text = "Maps", icon = icon("map"),
               menuSubItem(tabName = "Changes in Food Insecurity", text = "Changes in Food Insecurity"),
               menuSubItem(tabName = "foodInsecuritySWVA", text = "Food Insecurity SWVA"),
               menuSubItem(tabName = "foodOptions", text = "SWVA Food Options")
      ),
      #menuItem(tabName = "results", text = "Results", icon = icon("bar chart")),
      menuItem(tabName = "conclusion", text = "Conclusion", icon = icon("bar chart")),
      menuItem(tabName = "references", text = "Data Sources", icon = icon("book")),
      menuItem(tabName = "meettheteam", text = "Meet the Team", icon = icon("users"))


      
      #menuItem(tabName = "graphs", text = "Graphs", icon = icon("chart line"),
               #menuSubItem(tabName = "plotly", text = "Forecasted Food Insecurity Rates by County")
      #),
      #menuItem(tabName = "data", text = "Data", icon = icon("database"), 
               #menuSubItem(tabName = "allData", text = "All Data"),
               #menuSubItem(tabName = "forecastingVariables", text = "Forecasting Variables")
               

      )
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ),

    tabItems(
      tabItem(
        tabName = "overview",
        fluidRow(
          box(
            title = "Overview", width = 16, color = "blue",
            HTML("
        <style>
          .overview-text {
            text-align: justify;
            font-family: Arial, sans-serif;
            line-height: 1.6;
          }
          .overview-text h3 {
            font-size: 24px;
            color: #4169E1;
            margin-bottom: 10px;
          }
          .overview-text p {
            font-size: 16px;
            margin-bottom: 15px;
          }
          .background-text ul {
            font-size: 16px;
            margin-bottom: 15px;
            padding-left: 30px;
          }
        </style>
        
        <div class='overview-text'>
          <h3>Project Overview</h3>
          
          <p>The aim of this project was to simulate future food insecurity in Southwest Virginia. We used publicly available information, such as the U.S. Census Bureau’s American Community Survey (ACS) and Bureau of Labor Statistics (BLS) data, along with data compiled by Feeding America.
          When gathering this data, we focused on variables including income, age, educational attainment, and vehicle access which we found from existing literature to be potential determinants for food insecurity. We also selected variables used by Feeding America in their Map the Meal Gap report, such as unemployment and poverty rate. 
          Using a regression model in R, we simulated food insecurity rates for the years 2010 through 2022 at the state level, and then brought them down to the county and city level.
          We also ran an XGBoost machine learning model to simulate future food insecurity rates for the years 2023 through 2027 at the county and city level. </p>

          <p>We developed interactive maps that include food insecurity rates for both previous and future years, which are exhibited on this website to display our findings.
          Another map featured on this website shows the locations of farmers markets, grocery stores, dollar stores, and food pantries and distributors in Southwest Virginia that we gathered, as well as additional information. 
          The results of our project could be used by Feeding Southwest Virginia and other food programs to demonstrate a need for increased funding to specific areas that we found are likely to see a rise in food insecurity in future years.</p>
          
          <p>Goals:</p>
          <ul>
            <li>Gather and clean American Community Survey (ACS), Bureau of Labor Statistics (BLS), and Feeding America data</li>
            <li>Create plots exhibiting relationships between variables and food insecurity rates</li>
            <li>Run a regression on the data to simulate food insecurity rates in the past and future for Southwest Virginia counties and cities</li>
            <li>Develop interactive maps with the results of our simulation</li>
            <li>Design a shiny web app and a poster to display our project</li>
          </ul>
          
        </div>
      "),
              tags$figure(
                style = "border: 1px solid #ddd; padding: 10px; width: 400px; text-align: right;",
                tags$img(
                  src = "VTDSPG.jpeg",
                  width = 350,
                  alt = "picture of Virginia Tech Data Science for the Public Good"
                )
              )
            )
          )
      ),
      tabItem(
        tabName = "background",
        fluidRow(
          box(
            title = "Background", width = 16, color = "green",
            HTML("
        <style>
          .background-text {
            text-align: justify;
            font-family: Arial, sans-serif;
            line-height: 1.6;
          }
          .background-text h3 {
            font-size: 24px;
            color: #2E8B57;
            margin-bottom: 10px;
          }
          .background-text p {
            font-size: 16px;
            margin-bottom: 15px;
          }
          .background-text ul {
            font-size: 10px;
            margin-bottom: 15px;
            padding-left: 30px;
          }
          .background-text hr {
            border: none;
            border-top: 1px solid #ccc;
            margin: 20px 0;
          }
          .background-text .references {
            font-size: 14px;
            color: #888;
          }
        </style>
        
        <div class='background-text'>
          <h3>Background on Food Insecurity</h3>
          
          <p>Food security, as defined at the World Food Summit, exists “when all people at all times have access to sufficient, safe, nutritious food to maintain a healthy and active life” (Warr, 2014). Therefore, the lack of these characteristics signifies that people are experiencing food insecurity. 
          A variety of factors can increase the likelihood of food insecurity, including low income levels and unemployment (Waxman et al., 2022). This can lead to coping strategies such as reducing food intake or forgoing other health costs like medications (Gunderson & Ziliak, 2018). 
          The other aspect of food insecurity, the access to said food, can be hindered by limited access to places like grocery stores. Some rural areas do not have many stores to begin with, and urban areas can be flooded with cheap, unhealthy foods (Baxter & Park, 2024). 
          This can be compounded with a lack of transportation access to decrease the ability of people to obtain the affordable nutritious food they need (Hutton et al., 2022).</p>
          
          <p>The pervasive nature of lacking complete access to healthy food leads to a great number of negative health outcomes. In regards to mental health, researchers have found a positive relationship between food insecurity and risk of stress and depression (Pourmotabbed et al., 2020). Additionally, during the COVID-19 pandemic, it was found that mental health problems were highly 
          associated with food insecurity, with its effects shown to be three times that of losing a job in the pandemic (Fang et al., 2021). Food insecurity is also associated with unhealthy eating behaviors such as poor diet quality, binge eating and drinking, and substance use (Larson et al., 2020). This builds long-lasting habits that can impact people for the entirety of their lives and can lead to other health problems. 
          Among survey participants in a study published in 2019, food-insecure adults had estimated annual health care expenditures that were $1,834 higher than that of food-secure adults, showing that food insecurity can have a meaningful effect on a person's life outside of food itself (Berkowitz et al., 2019).</p>
          
          <h3>Southwest Virginia</h3>
          
          <p>Food insecurity is a widespread issue throughout Virginia, although counties in Southwest Virginia are often more highly impacted than other parts of the state due to lower income levels, lower educational attainment, and higher poverty rates. 
          Southwest Virginia is a mountainous and historically rural area of the commonwealth of Virginia. The area is located within the larger Appalachian region of the United States. In the 20th century, coal mining and agriculture were major economic drivers in the region. 
          However, with the decline in coal and reduced production of tobacco as a cash crop, the region's development, along with the rest of Appalachia, has stagnated (Southwest Virginia Economic Impact Analysis, 2016). These factors, along with others, drive many in Southwest Virginia into food insecurity. 
          According to Feeding America, 14.4% of people in Southwest Virginia, totaling 164,840 people, were food insecure in 2022 (Feeding southwest virginia, n.d.).</p>
          
          </div>
        "),
            tags$figure(
              class = "centerFigure",
              tags$img(
                src = "NewDataVCEStateDiagram.jpg",
                width = 700,
                alt = "map of Virginia and variables for southwest Virginia and the rest of Virginia"
              )
            ),
        HTML("
             <style>
          .background-text {
            text-align: justify;
            font-family: Arial, sans-serif;
            line-height: 1.6;
          }
          .background-text h3 {
            font-size: 24px;
            color: #2E8B57;
            margin-bottom: 10px;
          }
          .background-text p {
            font-size: 16px;
            margin-bottom: 15px;
          }
          .background-text ul {
            font-size: 10px;
            margin-bottom: 15px;
            padding-left: 30px;
          }
          .background-text hr {
            border: none;
            border-top: 1px solid #ccc;
            margin: 20px 0;
          }
          .background-text .references {
            font-size: 14px;
            color: #888;
          }
        </style>
        
        <div class='background-text'>
          <h3>Feeding Southwest Virginia</h3>
          
          <p>Feeding Southwest Virginia is a food bank partner of Feeding America that services 26 counties and nine cities located in the southwestern part of Virginia. In the area served by Feeding Southwest Virginia, one in seven people and one in five children face hunger (Hunger & Poverty, n.d.). 
          They distribute 18.4 million pounds of food each year through 400 partner programs such as churches or more localized food pantries. 
          They also run 11 mobile food pantries which bring food to more centralized locations for rural communities and operate community kitchens to teach adults how to prepare meals (Our impact, 2024).</p>
          
          <hr>
          
          <p>References:<br>
          <ul>
          <li>Warr, M. (2019). Food security. In <em>Encyclopedia of Food Security and Sustainability</em> (pp. 1-5). Elsevier.<br></li>
          <li>Feeding southwest virginia. (n.d.). <em>Feeding America</em>. Retrieved June 14, 2024, from https://www.feedingamerica.org/hunger-in-america/virginia/southwest-virginia<br></li>
          <li>Southwest Virginia Economic Impact Analysis. (2016). <em>Virginia Tech Office of Economic Development</em>.<br></li>
          <li>Hunger &amp; Poverty. (n.d.). <em>Feeding Southwest Virginia</em>. Retrieved June 14, 2024, from https://feedingswva.org/hunger-poverty/<br></li>
          <li>Our impact. (2024). <em>Feeding Southwest Virginia</em>. Retrieved June 14, 2024, from https://feedingswva.org/our-impact/<br></li>
          <li>Waxman, E., Salas, J., Gupta, P., & Karpman, M. (2022, September). Food insecurity trended upward in midst of high inflation ... https://www.urban.org/sites/default/files/2022-09/HRMS Food Insecurity Brief_0.pdf<br></li>
          <li>Gundersen, C., & Ziliak, J. P. (2018). Food insecurity research in the United States: Where we have been and where we need to go. <em>Applied Economic Perspectives and Policy</em>, 40(1), 119–135. https://doi.org/10.1093/aepp/ppx058<br></li>
          <li>Baxter, C., & Park, Y. M. (2024). Food Swamp Versus Food Desert: Analysis of geographic disparities in obesity and diabetes in North Carolina using GIS and spatial regression. <em>The Professional Geographer</em>, 1–16. https://doi.org/10.1080/00330124.2024.2306642<br></li>
          <li>Hutton, N. S., McLeod, G., Allen, T. R., Davis, C., Garnand, A., Richter, H., Chavan, P. P., Hoglund, L., Comess, J., Herman, M., Martin, B., & Romero, C. (2022). Participatory mapping to address neighborhood level data deficiencies for food security assessment in southeastern Virginia, USA.
          <em>International Journal of Health Geographics</em>, 21(1). https://doi.org/10.1186/s12942-022-00314-3<br></li>
          <li>Pourmotabbed, A., Moradi, S., Babaei, A., Ghavami, A., Mohammadi, H., Jalili, C., Symonds, M. E., & Miraghajani, M. (2020). Food insecurity and mental health: a systematic review and meta-analysis. <em>Public health nutrition</em>, 23(10), 1778–1790. https://doi.org/10.1017/S136898001900435X<br></li>
          <li>Fang, D., Thomsen, M.R. & Nayga, R.M. The association between food insecurity and mental health during the COVID-19 pandemic. <em>BMC Public Health</em> 21, 607 (2021). https://doi.org/10.1186/s12889-021-10631-0<br></li>
          <li>Larson, N., Laska, M. N., & Neumark-Sztainer, D. (2020). Food Insecurity, Diet Quality, Home Food Availability, and Health Risk Behaviors Among Emerging Adults: Findings From the EAT 2010-2018 Study. <em>American journal of public health</em>, 110(9), 1422–1428. https://doi.org/10.2105/AJPH.2020.305783<br></li>
          <li>Berkowitz, S. A., Basu, S., Gundersen, C., & Seligman, H. K. (2019). State-Level and County-Level Estimates of Health Care Costs Associated with Food Insecurity. <em>Preventing chronic disease</em>, 16, E90. https://doi.org/10.5888/pcd16.180549</li>
          </ul>
          </p>
             
            </div>
             ")
          )
        )
      ),
      # In ui.R
      tabItem(
        tabName = "methodology",
        box(
          width = 16,
          title = "Methodology",
          color = 'orange',
          tags$head(
            tags$style(HTML("
        .methodology-text {
          text-align: justify;
          font-family: Arial, sans-serif;
          line-height: 1.6;
        }
        .methodology-text h3 {
          font-size: 24px;
          color: #FF8C00;
          margin-bottom: 15px;
        }
        .methodology-text h4 {
          font-size: 20px;
          color: #FF8C00;
          margin-top: 20px;
          margin-bottom: 10px;
        }
        .methodology-text h5 {
          font-size: 18px;
          color: #FF8C00;
          margin-top: 15px;
          margin-bottom: 8px;
        }
        .methodology-text h6 {
          font-size: 12px;
          margin-top: 15px;
          margin-bottom: 8px;
        }
        .methodology-text p {
          font-size: 16px;
          margin-bottom: 15px;
        }
        .methodology-text ul, .methodology-text ol {
          font-size: 16px;
          margin-bottom: 15px;
          padding-left: 30px;
        }
        .methodology-text hr {
          border: none;
          border-top: 1px solid #ccc;
          margin: 20px 0;
        }
        .centerFigure {
          text-align: center;
          margin: 20px 0;
        }
        .centerFigure img {
          max-width: 100%;
          height: auto;
        }
        .main-content {
          width: 70%;
          float: left;
          padding-right: 20px;
        }
        .side-content {
          width: 30%;
          float: right;
          padding-left: 20px;
          border-left: 1px solid #ccc;
        }
        .clearfix::after {
          content: '';
          clear: both;
          display: table;
        }
        .nested-columns {
          display: flex;
          justify-content: space-between;
        }
        .nested-column {
          width: 48%;
        }
        .references {
          font-size: 14px;
          color: #888;
        }
      "))
          ),
          tabset(
            tabs = list(
              list(
                menu = "Our Model",
                content = div(
                  class = "methodology-text clearfix",
                  div(
                    class = "main-content",
                    #h3("Our Model"),
                    uiOutput("methodologyText"),
                    uiOutput("variableSelectionIntro"),
                    div(
                      class = "nested-columns",
                      div(
                        class = "nested-column",
                        uiOutput("compositeVariables")
                      ),
                      div(
                        class = "nested-column",
                        uiOutput("interactionTerms")
                      )
                    ),
                    uiOutput("dataPreparation"),
                    uiOutput("modelDevelopment"),
                    tags$hr(),
                    h4("Methodology Diagram"),
                    tags$figure(
                      class = "centerFigure",
                      tags$img(
                        src = "forecastDiagram.png",
                        width = "100%",
                        alt = "Diagram illustrating the methodology of our forecast model"
                      )
                    ),
                    tags$hr(),
                    div(
                      class = "references",
                      p("References:"),
                      tags$ul(
                        tags$li("Gundersen, C., Dewey, A., Engelhard, E., Strayer, M., & Lapinski, L. (2023). Map the Meal Gap: A Report on County and Congressional District Food Insecurity and County Food Cost in the United States in 2021. Feeding America.")
                      )
                    )
                  ),
                  div(
                    class = "side-content",
                    h4("Key Steps"),
                    uiOutput("keySteps"),
                    tags$hr(),
                    h4("Feature Importance"),
                    tags$figure(
                      class = "centerFigure",
                      tags$img(
                        src = "feature_importance_plotWithText.png",
                        width = "100%",
                        alt = "Bar graph displaying the most important variables to our model"
                      )
                    ),
                    tags$hr(),
                    h4("Data Preprocessing and Considerations"),
                    p("Our dataset encompasses county-level data for the continental United States, excluding Puerto Rico, Alaska, and Hawaii. The time frame spans from 2010 to 2022, aligning with the available ACS 5-year estimates."),
                    tags$div(
                      style = "font-size: 0.9em;",  # Slightly smaller font
                      p("To ensure data quality and consistency, we implemented the following data preprocessing steps:"),
                      tags$ul(
                        tags$li("Excluded Rio Arriba County due to missing ACS data for selected variables."),
                        tags$li("Removed counties with populations below 500 in any year between 2010 and 2022."),
                        tags$li("Merged Bedford City Virginia data with Bedford County Virginia for 2010-2013 using population-weighted averages (Bedford City is geographically located inside of Bedford County)."),
                        tags$li("Renamed Shannon County, South Dakota, to Oglala Lakota County for 2010-2014 data to reflect the official name change, allowing us to use Oglala Lakota County data from 2010-2022."),
                        tags$li("Utilized the Unemployment Rate data from the ACS 5 Year survey for Bedford City and Shannon County."),
                        tags$li("Included Connecticut at the state level alongside county-level data due to changes in Geographic Entity Identifiers (GEOID) and county regions in 2022."),
                        tags$li("For Jeff Davis County, Texas, which had no Median Income for the year 2020 in the ACS, we used the population-weighted average of 2019 and 2021."),
                        tags$li("The Poverty Rate we used subtracted out the poverty rates of undergraduate students in an area, to account for the growing body of research showing that this adversely affects the true poverty rate of an area."),
                        tags$li("Replicating Map the Meal Gap methodology, we decided to use the same race variables with the justification as their methodology listed, namely having adequate data at the county level.")
                      ),
                      p("These preprocessing steps helped us create a more accurate and consistent dataset for our analysis, addressing various data quality issues and ensuring comparability across different regions and time periods.")
                    )
                  )
                ),
                id = "modelTab"
              ), ##############################################################################################################
              list(
                menu = "Accuracy",
                content = div(
                  class = "methodology-text",
                  h3("Actual vs Predicted Food Insecurity Rates (2010-2022)"),
                  uiOutput("accuracyDescription"),
                  tags$figure(
                    class = "centerFigure",
                    tags$img(
                      src = "State_predicted_vs_actual_scatter_with_metrics.png",
                      width = 600,
                      alt = "Line graph depicting our accuracy rate overall"
                    )
                  ),
                  tags$hr(),
                  h3("Actual vs Predicted Food Insecurity Rates by State (2010-2027)"),
                  uiOutput("accuracyDescription2"),
                  tags$figure(
                    class = "centerFigure",
                    tags$img(
                      src = "All_States_FI_Rate_Projections2.png",
                      width = 800,
                      alt = "Line graphs depicting our accuracy rate by state"
                    )
                  ),
                  tags$figure(
                    class = "centerFigure",
                    tags$img(
                      src = "All_States_FI_Rate_Projections2.png",
                      width = 800,
                      alt = "Line graphs depicting our accuracy rate by state"
                    )
                  ),
                  tags$figure(
                    class = "centerFigure",
                    tags$img(
                      src = "All_States_FI_Rate_Projections3.png",
                      width = 800,
                      alt = "Line graphs depicting our accuracy rate by state"
                    )
                  ),
                  tags$figure(
                    class = "centerFigure",
                    tags$img(
                      src = "All_States_FI_Rate_Projections3.png",
                      width = 800,
                      alt = "Line graphs depicting our accuracy rate by state"
                    )
                  )
                )
              )
            ),
            id = "methodologyTabs",
            menu_class = "top attached tabular",
            tab_content_class = "bottom attached segment"
          )
        )
      ),
      tabItem(
        tabName = "conclusion",
        fluidRow(
          box(
            title = "Conclusion", width = 16, color = "purple",
            HTML("
        <style>
          .conclusion-text {
            text-align: justify;
            font-family: Arial, sans-serif;
            line-height: 1.6;
          }
          .conclusion-text h3 {
            font-size: 24px;
            color: #9135bd;
            margin-bottom: 10px;
          }
          .conclusion-text p, .conclusion-text ul {
            font-size: 16px;
            margin-bottom: 15px;
          }
          .conclusion-text ul {
            padding-left: 30px;
          }
          .conclusion-text hr {
            border: none;
            border-top: 1px solid #ccc;
            margin: 20px 0;
          }
        </style>
        
        <div class='conclusion-text'>
          
          <h3>Conclusion</h3>
          
          <p>Our results showed that there has been an overall downward trend in food insecurity in Southwest Virginia since 2010, despite a
          nationwide increase in 2022 due to the COVID-19 pandemic. We expect this decrease to continue through 2027, assuming the continuation of
          current food resource programs such as Feeding Southwest Virginia. This is demonstrated in the maps of 2010, 2022, and 2027 below.
          
          </div>
          "),
            tags$figure(
              class = "centerFigure",
              tags$img(
                src = "swva_predicted_fi_rates_map_2010_2022_2027.png",
                width = 1000,
                alt = "Southwest Virginia food insecurity rates map of 2010, 2022, and 2027"
              )
            ),
            HTML("
          <div class='conclusion-text'>
          
          <br><p>This trend is similar to the entire continental United States, although the rates most similarly match
          food insecurity rates in Appalachia. The diagram below shows our projected food insecurity rates for 2010 through
          2027 in Southwest Virginia, Virginia, Appalachia, and the continental United States. Years 2010 through 2022 use
          the American Community Survey variable values and years 2023 through 2027 use our ARIMA predicted values for those variables.</p>
          
          </div>
          "),
            tags$figure(
              class = "centerFigure",
              tags$img(
                src = "selectedenhanced_fi_rate_heatmap_selected_areasjul23.png",
                width = 1000,
                alt = "Heatmap demonstrating food insecurity rates by year by geographic region"
              )
            ),
          HTML("
          <div class='conclusion-text'>
          
          <p>The variables we found to be most important in predicting food insecurity in our model were:</p>
          
          <ul>
            <li>Percentage of the population without a high school degree</li>
            <li>Median income</li>
            <li>Poverty rate</li>
            <li>Income below $35,000 per year</li>
            <li>Cost per meal</li>
          </ul>
          
          <p>We believe that our projections demonstrate a need for additional support and funding in certain areas
          in Southwest Virginia. For instance, Washington County has a decrease in food insecurity rate of 0.6% from the years 2023 to 2027
          in our predictions, however that is a small change compared to a county such as Lee County which we predict will see a 3.1% decrease between those years. 
          Our projections also indicate that if Southwest Virginia's food insecurity rate was to decrease to match the rest of Virginia's rate by 2027, 
          it would result in 15,252 fewer food insecure individuals in the region. We hope that organizations like Feeding Southwest Virginia can utilize our
          findings to gain support from lawmakers and community members to reduce food insecurity in the future.</p>
          
        </div>
      ")
          )
        )

      ),
      tabItem(
        tabName = "references",
        fluidRow(
          box(
            title = "Data Sources", width = 16, color = "teal",
            HTML("
        <style>
          .references-text {
            text-align: justify;
            font-family: Arial, sans-serif;
            line-height: 1.6;
          }
          .references-text h3 {
            font-size: 24px;
            color: #00B2B3;
            margin-bottom: 10px;
          }
           .references-text h4 {
            font-size: 16px;
            font-family: Arial, sans-serif;
            margin-bottom: 15px;
            font-style: bold;
          }
          .references-text p {
            font-size: 16px;
            margin-bottom: 15px;
          }
          .references-text ul {
            font-size: 16px;
            margin-bottom: 15px;
            padding-left: 30px;
          }
        </style>
        
        <div class='references-text'>
          <h3>Data Sources</h3>
          
        </div>
      "),
            tags$div(
              style = "display: flex; justify-content: space-evenly;",
              tags$figure(
                class = "centerFigure",
                tags$img(
                  src = "ACS.jpg",
                  width = 200,
                  alt = "American Community Survey logo"
                ),
                tags$figcaption(style = "font-size: 16px;", HTML("The American Community Survey (ACS) is an ongoing
                                                                 U.S. Census Bureau survey that offers demographic, housing, 
                                                                 social, and economic data about the United States
                                                                 population. We used their data as some of our variables for 
                                                                 projecting food insecurity."))
              ),
              tags$figure(
                class = "centerFigure",
                tags$img(
                  src = "BLS.png",
                  width = 125,
                  alt = "Bureau of Labor Statistics logo"
                ),
                tags$figcaption(style = "font-size: 16px;", HTML("The Bureau of Labor Statistics (BLS) offers employment data
                                                                 about the United States that we used as some of our variables for
                                                                 projecting food insecurity."))
              ),
              tags$figure(
                class = "centerFigure",
                tags$img(
                  src = "FeedingAmerica.png",
                  width = 200,
                  alt = "picture of Mia Jones"
                ),
                tags$figcaption(style = "font-size: 16px;", HTML("Feeding America is a non-profit organization with a network of
                                                                 food banks that has a methodology of calculating food insecurity rates
                                                                 as well as data on variables such as cost per meal. Aspects of our project were
                                                                 guided by their food insecurity methodology and included some of their data."))
              )
            ),
          )
        )
      ),
      tabItem(
        tabName = "meettheteam",
        fluidRow(
          box(
            title = "Meet the Team", width = 16, color = "olive",
            HTML("
        <style>
          .meettheteam-text {
            text-align: justify;
            font-family: Arial, sans-serif;
            line-height: 1.6;
          }
          .meettheteam-text h3 {
            font-size: 24px;
            color: #8abd2b;
            margin-bottom: 10px;
          }
           .meettheteam-text h4 {
            font-size: 16px;
            font-family: Arial, sans-serif;
            margin-bottom: 15px;
            font-style: bold;
          }
          .meettheteam-text p {
            font-size: 16px;
            margin-bottom: 15px;
          }
        </style>
        
        <div class='meettheteam-text'>
          <h3>Meet the Team</h3>
          
          <p>The Data Science for the Public Good (DSPG) Young Scholars program is a summer immersive program held at the Virginia Tech Department of Agricultural and Applied Economics and the Virginia Cooperative Extension Service. In its fourth year, the program engages students from across the country to work together on projects that address state, federal, and local government challenges around critical social issues relevant in the world today. DSPG young scholars conduct research at the intersection of statistics, computation, and the social sciences to determine how information generated within 
          every community can be leveraged to improve quality of life and inform public policy. For more information on program highlights, how to apply, and our annual symposium, please visit the <a href='https://aaec.vt.edu/academics/undergraduate/dspg.html' target='_blank'>official VT DSPG website</a>.</p>
          
          <h3>Undergraduate Interns</h3>
        </div>
      "),
            tags$div(
              style = "display: flex; justify-content: space-evenly;",
            tags$figure(
              class = "centerFigure",
              tags$img(
                src = "emily2.jpg",
                width = 300,
                alt = "picture of Emily Gard"
              ),
              tags$figcaption(style = "font-size: 16px;", HTML("Emily Gard
                              <br><br>Virginia Tech, Undergraduate in Political Science and Sociology"))
            ),
            tags$figure(
              class = "centerFigure",
              tags$img(
                src = "nicholas.jpg",
                width = 300,
                alt = "picture of Nicholas Hamilton"
              ),
              tags$figcaption(style = "font-size: 16px;", HTML("Nicholas Hamilton
                              <br><br>Berea College, Undergraduate in Computer Science with a minor in Sociology"))
            ),
            tags$figure(
              class = "centerFigure",
              tags$img(
                src = "mia.jpg",
                width = 300,
                alt = "picture of Mia Jones"
              ),
              tags$figcaption(style = "font-size: 16px;", HTML("Mia Jones
                              <br><br>University of Massachusetts Lowell, Undergraduate in Business Administration
                              <br>(Marketing and Analytics/Operations Management)"))
              )
          ),
          HTML("
        <style>
          .meettheteam-text {
            text-align: justify;
            font-family: Arial, sans-serif;
            line-height: 1.6;
          }
          .meettheteam-text h3 {
            font-size: 24px;
            color: #8abd2b;
            margin-bottom: 10px;
          }
           .meettheteam-text h4 {
            font-size: 16px;
            font-family: Arial, sans-serif;
            margin-bottom: 15px;
            font-style: bold;
          }
          .meettheteam-text p {
            font-size: 16px;
            margin-bottom: 15px;
          }
        </style>
        
        <div class='meettheteam-text'>
          
          <h3>VT Faculty Members</h3>
        </div>
      "),
          tags$div(
            style = "display: flex; justify-content: space-evenly;",
            tags$figure(
              class = "centerFigure",
              tags$img(
                src = "susan.jpg",
                width = 300,
                alt = "picture of Susan Chen"
              ),
              tags$figcaption(style = "font-size: 16px;", HTML("Dr. Susan Chen
                                                               <br><br> Associate Professor of Agricultural and Applied Economics"))
            ),
            tags$figure(
              class = "centerFigure",
              tags$img(
                src = "michael.jpg",
                width = 300,
                alt = "picture of Michael Cary"
              ),
              tags$figcaption(style = "font-size: 16px;", HTML("Dr. Michael Cary
                                                               <br><br> Research Assistant Professor of Agricultural and Applied Economics"))
            ),
            tags$figure(
              class = "centerFigure",
              tags$img(
                src = "eric.jpg",
                width = 300,
                alt = "picture of Eric Kaufman"
              ),
              tags$figcaption(style = "font-size: 16px;", HTML("Dr. Eric Kaufman
                                                               <br><br> Professor and Associate Department Head 
                                                               <br>of Agricultural, Leadership, and Community Education"))
            )
          ),
          HTML("
        <style>
          .meettheteam-text {
            text-align: justify;
            font-family: Arial, sans-serif;
            line-height: 1.6;
          }
          .meettheteam-text h3 {
            font-size: 24px;
            color: #8abd2b;
            margin-bottom: 10px;
          }
           .meettheteam-text h4 {
            font-size: 16px;
            font-family: Arial, sans-serif;
            margin-bottom: 15px;
            font-style: bold;
          }
          .meettheteam-text p {
            font-size: 16px;
            margin-bottom: 15px;
          }
        </style>
        
        <div class='meettheteam-text'>
          
          <h3>DSPG Graduate Student Fellow</h3>
        </div>
      "),
          tags$figure(
            class = "centerFigure",
            tags$img(
              src = "piper.jpg",
              width = 300,
              alt = "picture of Piper Zimmerman"
            ),
            tags$figcaption(style = "font-size: 16px;", HTML("Piper Zimmerman
                                                             <br><br>Virginia Tech, Graduate Student Fellow in Statistics"))
          ),
          HTML("
        <style>
          .meettheteam-text {
            text-align: justify;
            font-family: Arial, sans-serif;
            line-height: 1.6;
          }
          .meettheteam-text h3 {
            font-size: 24px;
            color: #8abd2b;
            margin-bottom: 10px;
          }
           .meettheteam-text h4 {
            font-size: 16px;
            font-family: Arial, sans-serif;
            margin-bottom: 15px;
            font-style: bold;
          }
          .meettheteam-text p {
            font-size: 16px;
            margin-bottom: 15px;
          }
        </style>
        
        <div class='meettheteam-text'>
          
          <h3>Project Stakeholder</h3>
          
          <p>Feeding Southwest Virginia<p>
          
        </div>
      ")
        )
        )
      ),
      tabItem(
        tabName = "allData",
        fluidRow(
          box(
            title = "all Data", width = 16, color = "orange",
            dataTableOutput("allDataTable")
          )
        )
      ),
      tabItem(
        tabName = "forecastingVariables",
        fluidRow(
          box(
            title = "County Selection", width = 3, color = "teal",
            selectInput("countySelection", "Select County", choices = unique_years)
          ),
          box(
            title = "Forecasting Variables", width = 9, color = "purple",
            div(
              style = "width: 100%; height: 600px",#; overflow: hidden;",
              imageOutput("countyImage", height = "50%", width = "50%", inline = TRUE)
            )
          )
        )
      ),
      tabItem(
        tabName = "Changes in Food Insecurity",
        fluidRow(
          # box(
          #   title = "Map Layers", width = 3, status = "primary", solidHeader = TRUE,
          #   checkboxInput("farmersMarketsCheckbox", "Farmers Markets", value = FALSE),
          #   checkboxInput("groceryDollarStoresCheckbox", "Grocery & Dollar Stores", value = FALSE)
          # ),
          box(
            title = "Instructions", width = 12, color = "teal", status = "primary", solidHeader = TRUE,
          HTML("
        <style>
          .ChangesinFoodInsecurity-text {
            text-align: justify;
            font-family: Arial, sans-serif;
            line-height: 1.6;
          }
          .ChangesinFoodInsecurity-text h3 {
            font-size: 22px;
            color: #000000;
            margin-bottom: 10px;
          }
           .ChangesinFoodInsecurity-text h4 {
            font-size: 16px;
            font-family: Arial, sans-serif;
            margin-bottom: 15px;
            font-style: bold;
          }
          .ChangesinFoodInsecurity-text p {
            font-size: 15px;
            margin-bottom: 15px;
          }
        </style>
        
        <div class='ChangesinFoodInsecurity-text'>
          
          <h3>Changes in Food Insecurity Rates in Southwest Virginia</h3>
          
          <p>This map shows changes in food insecurity rates by county or city in southwest Virginia. The rates shown are simulated food insecurity rates 
          we developed in our project that include variables used in Feeding America's Map the Meal Gap project as well as additional variables selected by us.
          You can select the two years to compare using the dropdown box on the right side, and can click each county or city on the map to view their change in food insecurity rate between the selected years.<br><br>
          Green represents a decrease in food insecurity rate between the years, with the exception of years where there were no counties/cities that saw a decrease, in which case the counties/cities with the lowest increase will appear green.<br><br>
          Purple represents an increase in food insecurity rate between the years, with the exception of years where there were no counties/cities that saw an increase, in which case the counties/cities with the lowest decrease will appear purple.</p>
          
        </div>
      ")
          ),
          box(
            title = "Leaflet Map", width = 9, color = "purple", status = "primary", solidHeader = TRUE,
            leafletOutput("foodInsecurityChanges", height = "600px")
          ),
          box(
            title = "Year Selection", width = 3, color = "teal", status = "primary", solidHeader = TRUE,
            selectInput("year1", "Select First Year", choices = 2010:2027, selected = 2021),
            selectInput("year2", "Select Second Year", choices = 2010:2027, selected = 2022)
          )
        )
      ),
      tabItem(
        tabName = "foodInsecuritySWVA",
        fluidRow(
          column(
            width = 3,
            box(
              title = "Year Selection", width = 12, color = "teal",
              selectInput("yearSelection", "Select Year", choices = unique_years, selected = 2022)
            ),
            #box(
              #title = "Cost Per Meal", width = 12, color = "teal",
              #sliderInput("slider1", label = h3("Select Increase in Cost Per Meal (%)"), min = 0,
                          #max = 10, value = 5, step = 1, post = "%")
              #)
          ),
          column(
            width = 9,
            box(
              title = "Instructions", width = 12, color = "teal", status = "primary", solidHeader = TRUE,
              HTML("
        <style>
          .foodInsecuritySWVA-text {
            text-align: justify;
            font-family: Arial, sans-serif;
            line-height: 1.6;
          }
          .foodInsecuritySWVA-text h3 {
            font-size: 22px;
            color: #000000;
            margin-bottom: 10px;
          }
           .foodInsecuritySWVA-text h4 {
            font-size: 16px;
            font-family: Arial, sans-serif;
            margin-bottom: 15px;
            font-style: bold;
          }
          .foodInsecuritySWVA-text p {
            font-size: 15px;
            margin-bottom: 15px;
          }
        </style>
        
        <div class='foodInsecuritySWVA-text'>
          
          <h3>Food Insecurity Rates in Southwest Virginia</h3>
          
          <p>This map shows food insecurity rates by county or city in southwest Virginia. 
          The rates shown are simulated food insecurity rates 
          we developed in our project that include variables used in Feeding America's Map the Meal Gap project as well as additional variables selected by us.
          You can use the dropdown box on the left to select a year and click each county or city on the map to view their food insecurity rate for that year.
          The boxes on the right display the average food insecurity rates, poverty rates, and unemployment rates by geographical region for the selected year.</p>
          
        </div>
      ")
            ),
            box(
              title = "Leaflet Map", width = 12, color = "purple",
              leafletOutput("foodInsecurityMap", height = "600px")
            )
          ),
          column(
            width = 3,
            box(
              title = "United States", width = 12, color = "teal",
              fluidRow(
                column(4, tags$div(style = "font-size: 13px;", textOutput("unitedStates_mean_FI_Rate_Year"))),  # Font size for Food Insecurity Rate
                column(4, tags$div(style = "font-size: 13px;", textOutput("unitedStates_mean_POV_Year"))),      # Font size for Poverty Rate
                column(4, tags$div(style = "font-size: 13px;", textOutput("unitedStates_mean_UN_Year"))) 
              )
            ),
            box(
              title = "Appalachia", width = 12, color = "teal",
              fluidRow(
                column(4, tags$div(style = "font-size: 13px;", textOutput("appalachia_mean_FI_Rate_Year"))),  # Font size for Food Insecurity Rate
                column(4, tags$div(style = "font-size: 13px;", textOutput("appalachia_mean_POV_Year"))),      # Font size for Poverty Rate
                column(4, tags$div(style = "font-size: 13px;", textOutput("appalachia_mean_UN_Year"))) 
              )
            ),
            box(
             title = "Virginia", width = 12, color = "teal",
            fluidRow(
              column(4, tags$div(style = "font-size: 13px;", textOutput("all_VA_mean_FI_Rate_Year"))),  # Font size for Food Insecurity Rate
              column(4, tags$div(style = "font-size: 13px;", textOutput("all_VA_mean_POV_Year"))),      # Font size for Poverty Rate
              column(4, tags$div(style = "font-size: 13px;", textOutput("all_VA_mean_UN_Year"))) 
            )
          ),
            box(
             title = "Southwest Virginia", width = 12, color = "teal",
            fluidRow(
              column(4, tags$div(style = "font-size: 13px;", textOutput("SWVA_mean_FI_Rate_Year"))),  # Font size for Food Insecurity Rate
              column(4, tags$div(style = "font-size: 13px;", textOutput("SWVA_mean_POV_Year"))),      # Font size for Poverty Rate
              column(4, tags$div(style = "font-size: 13px;", textOutput("SWVA_mean_UN_Year"))) 
               )
             ),
            box(
              title = "Data Sources", width = 12, color = "teal",
              fluidRow(
                HTML("
        <style>
          .DataSourcesMap-text p {
            font-size: 12px;
            margin-bottom: 15px;
          }
        </style>
        
        <div class='DataSourcesMap-text'>
          
          <p>Food insecurity rates were developed in our project.
          Variable data is from Feeding America, the Bureau of Labor Statistics (BLS), and the American Community Survey (ACS).</p>
          
        </div>
      ")
                
              )
            )
          )
        )
      ),
      #Southwest Virginia Food Options tab
      tabItem(
        tabName = "foodOptions",
        fluidRow(
          column(
            width = 12,
            box(
              title = "Instructions", width = 12, color = "teal", status = "primary", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
              HTML("
          <style>
            .foodOptions-instructions {
              text-align: justify;
              font-family: Arial, sans-serif;
              line-height: 1.6;
            }
            .foodOptions-instructions h3 {
              font-size: 22px;
              color: #000000;
              margin-bottom: 10px;
            }
            .foodOptions-instructions h4 {
              font-size: 18px;
              color: #2c3e50;
              margin-top: 15px;
              margin-bottom: 10px;
            }
            .foodOptions-instructions p {
              font-size: 15px;
              margin-bottom: 15px;
            }
            .foodOptions-instructions ul {
              padding-left: 20px;
            }
            .foodOptions-instructions li {
              margin-bottom: 5px;
            }
          </style>
          
          <div class='foodOptions-instructions'>
            <h3>Southwest Virginia Food Options Map</h3>
            
            <p>This interactive map displays food insecurity rates and various food-related locations across Southwest Virginia. The map is designed to help you understand the food landscape in the region.</p>
            
            <h4>Map Features:</h4>
            <ul>
              <li><strong>County Colors:</strong> Each county is colored based on its food insecurity rate from 2022. Darker colors indicate higher rates of food insecurity.</li>
              <li><strong>Interactive Layers:</strong> Use the checkboxes on the left to show or hide different types of food-related locations, including farmers markets, grocery stores, dollar stores, and food pantries/distributors.</li>
              <li><strong>Clickable Elements:</strong> Click on a county to view its name, GEOID, and food insecurity rate, or click on a location marker for more detailed information about the specific food source.</li>
            </ul>
            
              <p>This map can help identify areas with high food insecurity and visualize the distribution of various food sources across Southwest Virginia.</p>
          </div>
        ")
            )
          )
        ),
        fluidRow(
          column(
            width = 3,
            box(
              title = "Map Layers", width = 12, color = "teal",
              checkboxInput("fiMapFarmersMarketsCheckbox", "Farmers Markets", value = FALSE),
              checkboxInput("fiMapGroceryStoresCheckbox", "Grocery Stores", value = FALSE),
              checkboxInput("fiMapDollarStoresCheckbox", "Dollar Stores", value = FALSE),
              checkboxInput("fiMapFoodDistributorsCheckbox", "Food Pantries/Distributors", value = FALSE)
            )
          ),
          column(
            width = 9,
            box(
              title = "Southwest Virginia Food Options Map", width = 12, color = "purple",
              leafletOutput("foodOptionsMap", height = "600px")
            )
          ),
          box(
            title = "Data Sources", width = 3, color = "teal",
            fluidRow(
              HTML("
        <style>
          .DataSourcesMap-text p {
            font-size: 12px;
            margin-bottom: 15px;
          }
        </style>
        
        <div class='DataSourcesMap-text'>
          
          <p>Food insecurity rates were developed in our project. Variable data is from Feeding America, the Bureau of Labor Statistics (BLS), and the American Community Survey (ACS). Store location information is from the 
          Virginia Farmers Market Association website, store websites, and the Feeding Southwest Virginia website.

          <br> Note: The food pantries/distributors category contains locations found on the Feeding Southest Virginia
          website that offer food assistance. Some locations are food pantries, while others offer food in different ways.</p>
          
        </div>
      ")
              
            )
          )
        )
      )
      #tabItem(
        #tabName = "plotly",
        #fluidRow(
          #column(
            #width = 16,
            #plotlyOutput("plotly", height = "1000px")  # Adjust the height as needed
         # )
       # )
     # )
    )
  )
)
