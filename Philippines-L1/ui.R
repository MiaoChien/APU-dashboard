library(shiny)
source("funcs.R")

navbarPage(
    id = "navbar",
    title = "APU Dashboard",
    windowTitle = "APU Dashboard", #title for browser tab
    theme = shinytheme("cerulean"), #Theme of the app (blue navbar)
    collapsible = TRUE, #tab panels collapse into menu in small screens
    header = tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = cssFile),
        # HTML("<html lang='en'>"),
        # tags$link(rel="shortcut icon", href="favicon_scotpho.ico"), #Icon for browser tab
        #Including Google analytics
        #includeScript("google-analytics.js"),
        HTML("<base target='_blank'>")
    ),
    tabPanel(
        withMathJax(),
        title = COUNTRY,
        fluidPage(class="main-page",
                  column(width = 7, class="left-control-panel col-md-7 col-sm-12",
                         ##### MAP CONTENT #####
                         div(class="theMap",
                             withSpinner(leafletOutput("main_map"), type=4, size=1.5)
                         )
                  ),
                  column(width = 5, class="right-control-panel col-md-5 col-sm-12",
                         
                         #### 2 row type ####
                         fluidRow(
                             column( width = 12,
                                     fluidRow(
                                         column(width=6,
                                                radioGroupButtons(
                                                    inputId = "theme_selector",
                                                    label = "Select theme:",
                                                    choices = c(
                                                        "AQ Station" = "AQ Station",
                                                        'PM\\(_{2.5} \\)' = "PM2.5"
                                                    ),
                                                    justified = TRUE,
                                                    checkIcon = list(yes = icon("ok", lib = "glyphicon"))
                                                )
                                          ),
                                         column(width = 6,
                                             pickerInput(
                                                 inputId = "pop_selector",
                                                 label = "select group population ",
                                                 choices = c("All Population"="all",
                                                             "Infants (0-4)" ="child",
                                                             "Elderlies (65+)" = "old",
                                                             "Pregnant Woman" = "pregs"
                                                 )
                                             )
                                         )
                                     ),
                                     fluidRow(
                                         uiOutput("ui_desc"),
                                     )
                             )

                         ), 
                         fluidRow(
                             tabsetPanel(
                                 id = "tabs_viewType",
                                 type = "tabs",
                                 tabPanel("Selected Area",
                                          uiOutput("ui_city_situaion"),
                                          plotlyOutput("plot_city_propotion")
                                 ),
                                 tabPanel("Ranking Plot",
                                          
                                          ##### 2 row style ######
                                          fluidRow(
                                              plotlyOutput("rank_stacked_chart", width = "100%", height = "40vh")
                                          ),
                                          fluidRow(
                                              column(width=2),
                                              column(width=8,
                                                     conditionalPanel(
                                                         condition = "input.theme_selector=='PM2.5'",
                                                         radioGroupButtons(
                                                             inputId = "select_pm25_rank_order",
                                                             label = "Choose ranking method",
                                                             choices = c("Lowest exposure"="group_a_prec",
                                                                         "Highest exposure"="group_c_prec"
                                                             ),
                                                             checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                                             justified = TRUE
                                                         )
                                                     )
                                              ),
                                              column(width=2),
                                              
                                              
                                          )
                                          
                                          ##### 2 column style ######
                                          # column(width = 3,
                                             # conditionalPanel(
                                             #     condition = "input.theme_selector=='PM2.5'",
                                             #     wellPanel(
                                             #         radioGroupButtons(
                                             #             inputId = "select_pm25_rank_order",
                                             #             label = "select rank order",
                                             #             choices = c("Lowest exposure"="group_a_prec",
                                             #                         "Highest exposure"="group_c_prec"
                                             #             ),
                                             #             checkIcon = list(
                                             #                 yes = icon("ok", lib = "glyphicon")),
                                             #             direction = "vertical"
                                             #         )
                                             #     )
                                             # )
                                          # ),
                                          # column(width = 9,
                                          #        plotlyOutput("rank_stacked_chart", width = "500px", height = "40vh")
                                          # )
                                          
                                 )
                                 
                                 
                             )
                             
                         )
                         
                  )
                  
        )
    ),
    navbarMenu(
        title = "Select country",
        HTML(paste0('
                 <a href="',DOMAIN, "Colombia-L1/", '" target="_self">Colombia</a>
                 <a href="',DOMAIN, "India-L1/", '" target="_self">India</a>
                 <a href="',DOMAIN, "Indonesia-L1/", '" target="_self">Indonesia</a>
                 <a href="',DOMAIN, "Malaysia/", '" target="_self">Malaysia</a>
                 <a href="',DOMAIN, "Philippines-L1/", '" target="_self">Philippines</a>
                 <a href="',DOMAIN, "SouthAfrica-L1/", '" target="_self">South Africa</a>
                 <a href="',DOMAIN, "Thailand-L1/", '" target="_self">Thailand</a>
                 <a href="',DOMAIN, "Turkey-L1/", '" target="_self">Turkey</a>
            '))
    )
    
)
