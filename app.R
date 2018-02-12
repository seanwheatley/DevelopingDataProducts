
library(shiny)
library(leaflet)
library(shinythemes)
library(datasets)


ui <- fluidPage(theme = shinytheme("simplex"),
   
   # Application title
   titlePanel("Earthquake View: Fiji"),
   
   tabsetPanel(
       tabPanel("Documentation",
       p("This application allows the user to view Earthquakes that occured in Fiji since 1964 that had a registered magnitude of at least 4.  The sliders can be used to adjust the amount of earthwuakes in view, based on magnitude, depth, and number of stations reporting."),
       p("Once the sliders are set, the user can zoom in and move around on the map to view where individual Earthquakes occurred. Each circle represents a single earthquake, with larger circles representing earthquakes of larger magnitude.")
       ),
       tabPanel("Application",
                # Sidebar with a slider input for filtering
                sidebarLayout(
                    sidebarPanel(
                        h3("Filters"),
                        p("Use the sliders below to reduce the number of earthquakes in the view. Filter by magnitude, depth, and number of stations that reported."),
                        sliderInput("mag",
                                    "Select Range of Magnitudes to View:",
                                    min = 4,
                                    max = 6.4,
                                    value = c(4,6.4),
                                    step = .05),
                        sliderInput("depth",
                                    "Select Range of Depths to View:",
                                    min = 40,
                                    max = 680,
                                    value = c(40,680),
                                    step = 5),
                        sliderInput("station",
                                    "Number of Stations Reporting",
                                    min = 10,
                                    max = 132,
                                    value = c(10,132),
                                    step = 1)
                    ),
                    
                    # Show map
                    mainPanel(
                        leafletOutput("map"),
                        h3(textOutput("nquakes"))
                    )
                )
       )
   )
)
# Define server logic required to draw a histogram
server <- function(input, output){
   
    data = reactive({
        x = data.frame(quakes)
        x = x[x$mag >= input$mag[1] & x$mag <= input$mag[2],]
        x = x[x$depth >= input$depth[1] & x$depth <= input$depth[2],]
        x = x[x$station >= input$station[1] & x$station <= input$station[2],]
        x
    })
    
    
    output$map = renderLeaflet({
        leaflet() %>% addTiles() %>% addCircleMarkers(lng = data()$long, lat = data()$lat,
                                                      clusterOptions = markerClusterOptions(),
                                                      radius = (data()$mag -1.5)^2)
    })
    
    output$nquakes = renderText({as.character(paste0("Earthquake Count: ",nrow(data())))})
  
}

# Run the application 
shinyApp(ui = ui, server = server)

