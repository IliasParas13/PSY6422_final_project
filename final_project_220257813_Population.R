# Variables with first letter capital in each word are Matrices.
# Variables with only the first letter capital are Column titles.
# Variables with no capital letters, non of the above.
# Two ## means it is a topic.
# One # means it is an explanation of the following line/es.
# One # next to a code is a comment.
# 1 empty line  means that the topic is similar.
# 2 empty lines means that the topic changes.
# If you are looking for something, sit back to your chair and read the ## comments.

# You might need to change the line of the path to your path.

library(readr) # Read files: CSV
library(stringr) # String manipulation to extract countries with specific string characteristics.
library(dplyr) # Data manipulation: summarise, arrange, group, etc. 
library(ggplot2) # simple plot
library(plotly)  # Display the plot in a separate window
library(sf) # Simple Features: read shape file and merge spatial data frame with population data
library(leaflet) # Create interactive maps: remove shape layers, modify maps, polygon layer
library(shiny)   # Interactive window


## Read population data and shapefile
setwd("C:/Users/ilias/OneDrive/Εκαπαίδευση/Master/Data Analysis and Visualization")
# Read shapefile
world_sf <- st_read("TM_WORLD_BORDERS_SIMPL-0.3.shp")
Unmodified_Data <- read.delim("population-and-demography.csv", header = TRUE, sep = ",")
Population_Data <- Unmodified_Data[ , 1:3] # data I need.
colnames(Population_Data)[1] <- "Country"  # I didn't want the dot.

## Useful variables
year_start = min(Unmodified_Data$Year)
year_end   = max(Unmodified_Data$Year)
year_step  = Unmodified_Data[2,2]-Unmodified_Data[1,2]
year_today = as.numeric(format(Sys.Date(), "%Y"))


## Total Population by Year
Continents <- Population_Data[grepl("\\(UN\\)", Population_Data$Country), ]
Sum_by_Year <- aggregate(Population ~ Year, data = Continents, sum)
Sum_by_Year$Population <- Sum_by_Year$Population/1e9 # in billions

# Plot Total Population per Year
plot(Sum_by_Year[(1:(year_today-year_start+1)),], main = "Total Population by Year", xlab = "Year", ylab = "Population in billions",
          type = "o", col = "steelblue", pch = 19)

# ## Population difference of each country
# # Create matrix with difference between first and last year.
# First_Last_Population <- Population_Data %>%
#        group_by(Country) %>%
#        summarise(First_year_pop = Population[which.min(Year)],
#                  Last_year_pop = Population[which.max(Year)])
# First_Last_Population <- First_Last_Population %>%
#   mutate(
#     Diff_pop = Last_year_pop - First_year_pop,
#     Perc_diff = (Diff_pop / First_year_pop) * 100
#   )
# 
# # Plot the Population difference of each country
# gg <- ggplot(First_Last_Population, aes(x = reorder(Country, Diff_pop), y = Diff_pop)) +
#   geom_col(aes(fill = ifelse(Diff_pop < 0, "red", "steelblue"))) +
#   labs(title = "Population Difference",
#        y = "Difference in Population",
#        x = "Country") +
#   coord_flip()
# p <- ggplotly(gg)
# plotly::ggplotly(p)


## Shiny UI
# Interface of the main chart.
ui <- fluidPage(
  titlePanel("World Population per Country"),
  sliderInput("yearInput", "Select Year", min = year_start, max = year_end, value = year_start),
              #animate = animationOptions(interval = 1000, loop = FALSE)),
  
  # Updatable subtitle (show the total population of the selected year).
  h2(textOutput("subtitle")),
  
  # Size of the main panel.
  mainPanel(leafletOutput("map", width = "150%", height = "500px"))
)


## Shiny server
server <- function(input, output, session) {
  
  # Update the subtitle text to show the total population of the selected year
  output$subtitle <- renderText({
    title <- paste("Total Population for the Year ",input$yearInput, ": ", format(Sum_by_Year[Sum_by_Year$Year == input$yearInput, "Population"], big.mark = ","))
    title
  })
  
  # Filter data based on selected year
  filtered_data <- reactive({
    Population_Data %>% filter(Year == input$yearInput)
  })
  
  # Create the leaflet map
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>% # I am not sure what this is...
      setView(lng = 0, lat = 30, zoom = 2)
  })
  
  # Add choropleth polygons to the map
  observe({
    # Merge population data with shapefile data
    merged_data <- merge(world_sf, filtered_data(), by.x = "NAME", by.y = "Country", all.x = TRUE)
    
    # Create the choropleth map
    leafletProxy("map") %>%
      clearShapes() %>%
      addPolygons(
        data = merged_data,
        fillColor = ~colorNumeric(palette = "YlOrRd", domain = Population)(Population),
        color = "white",
        weight = 1,
        opacity = 0.7,
        fillOpacity = 0.8,
        highlightOptions = highlightOptions(color = "red", weight = 2), # When you put the cursor on a country, will be highlited.
        label = ~paste(NAME, ": ", format(Population, big.mark = ","))  # Numbers with commas as thousands separators for easy read.
      )
  })
}


## Run the Shiny app
shinyApp(ui, server)