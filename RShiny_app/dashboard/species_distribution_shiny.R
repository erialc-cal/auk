#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
server_1 <- function(input, output, session) {
    ebd_filtered <- read.csv('data/preprocessed_1.csv')
    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')

    })

}


server_2 <- function(input, output) {
  output$map <- renderLeaflet({
    if (input$year != "All Years") {
      df <- subset(ebd_filtered, year == input$year)
    }
    if (input$state != "All States") {
      df <- subset(df, state == input$state)
    }
    
    if(input$display == "All species") {
      tmp <- df %>% group_by(common_name) %>% summarize(detection = mean(as.numeric(species_observed)), lng = median(longitude), lat = median(latitude))
      m <- leaflet(data = df) %>%
      addTiles() %>% 
      setView(lng = mean(tmp$lng), lat = mean(tmp$lat), zoom = 8)
      pal <- colorQuantile("YlOrRd", tmp$detection, n = 4)
      m <- addCircleMarkers(m, ~longitude, ~latitude, 
                            color = ~pal(tmp$detection),
                            radius = 5, 
                            fillOpacity = 0.5,
                            popup =  ~paste(paste(paste("Observation counts", round(tmp$detection, 2)), 'Species'), tmp$common_name))
      m %>% addLegend(data = tmp,
        pal = pal,
        values = ~detection,
        position = "bottomleft",
        title = "Detection counts:",
        opacity = 0.9
      ) 
      
    } else {
      # data 
      tmp <- df %>% subset(common_name == input$display)  # %>% group_by(latitude, longitude) %>% summarize(observation_count = sum(as.numeric(observation_count), na.rm = TRUE))
      tmp$observation_count[tmp$observation_count == 'X'] <- mean(tmp$observation_count, na.rm = TRUE)
      tmp$observation_count <- as.numeric(tmp$observation_count)
      tmp$observation_count[is.na(tmp$observation_count)] <- mean(tmp$observation_count, na.rm = TRUE)
      # map 
      m <- leaflet(data = tmp) %>%
      addTiles() %>%
      setView(lng = mean(tmp$longitude), lat = mean(tmp$latitude), zoom = 5)
      pal <- colorBin("YlOrRd", tmp$observation_count, 3)
      m <- addCircleMarkers(m, ~tmp$longitude, ~tmp$latitude, 
                            color = ~pal(tmp$observation_count),
                            radius = 3, 
                            fillOpacity = 0.5,
                            popup = ~paste("Observation counts", round(as.numeric(tmp$observation_count, na.rm = TRUE), 2))
      )
    }
  })
  
}




