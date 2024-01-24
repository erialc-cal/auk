
if (!require("shiny")) {
  install.packages("shiny")
  library(shiny)
}
if (!require("shinyWidgets")) {
  install.packages("shinyWidgets")
  library(shinyWidgets)
}
if (!require("shinythemes")) {
  install.packages("shinythemes")
  library(shinythemes)
}
if (!require("leaflet")) {
  install.packages("leaflet")
  library(leaflet)
}
if (!require("leaflet.extras")) {
  install.packages("leaflet.extras")
  library(leaflet.extras)
}
if (!require("shinydashboard")){
  install.packages('shinydashboard')
  library(shinydashboard)
}


source("dashboard/species_distribution_shiny.R", local = TRUE)
source("dashboard/plot_3.R")
source("dashboard/plot_2.R", local = TRUE)
source("dashboard/data_preprocessing.R", local = TRUE)
#source("doc/descriptive_maps_property_actions.R", local = TRUE)
#source("doc/prediction_plot_app.R", local = TRUE)



ui <- dashboardPage(
  dashboardHeader(title="Bird species dashboard"),
  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Species distributions", tabName = "sd", icon = icon('dashboard',verify_fa = FALSE)),
      menuItem("Species distributions (2)", tabName = "sd2", icon = icon("dashboard",verify_fa = FALSE)),
      menuItem("Trends and predictions", tabName = "to", icon = icon("th",verify_fa = FALSE))
    #  menuItem("Data heterogeneity", tabName = "dh", icon = icon("dashboard")),
    #  menuItem("References and sources", tabName = "rs", icon = icon("th"))
      )
    ),
  ## Body content
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "sd",
              fluidRow(
                box(plotOutput("plot1", height = 250)),

                box(
                  title = "Controls",
                  selectInput("state", "Select State:",
                              choices = c("All States", unique(ebd_filtered$state)), 
                              selected = "All States")
                )
              )
      ),

      # Second tab content
      tabItem(tabName = "sd2",
              h2("Species distribution"),
              fluidPage(
                sidebarLayout(
                  sidebarPanel(
                    selectInput("display", "Choose species:",
                                choices = c("All species", sort(unique(ebd_filtered$common_name))), selected = "Eurasian Kestrel"),
                    selectInput("year", "Select Year of observation:",
                                choices = c("Choose year...", sort(unique(ebd_filtered$year))), 
                                selected = "All Years"),
                    selectInput("state", "Select State:",
                                choices = c("All States", unique(ebd_filtered$state)), 
                                selected = "All States")  
                  ),
                  
                  mainPanel(
                    leafletOutput("map")
                  )
                )
              )
            ),

      tabItem(tabName = "to",
              h2("Trends and predictions"),
              fluidRow(
                box(plotOutput("plotx", height = 250)),
                
                box(
                  title = "Controls",
                  sliderInput("slider", "Years", min(ebd_filtered$year), max(ebd_filtered$year), median(ebd_filtered$year))
                )
              )
      # ),
      # 
      # tabItem(tabName = "dh",
      #         h2("Data heterogeneity")
      # ),
      # 
      # tabItem(tabName = "rs",
      #         h2("Reference and sources")
      )
    )
  )
)





server <- function(input, output, session) {
  server_1(input, output,session)
  server_2(input, output)
#  server_3(input, output, session)
#  server_4(input, output, session)
}


shinyApp(ui, server)

#rsconnect::deployApp(appPrimaryDoc = "RShiny_app/app.R")