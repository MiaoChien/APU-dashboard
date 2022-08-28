
library(shiny)
source("funcs.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {


# MAP ---------------------------------------------------------------------
    output$main_map <- leaflet::renderLeaflet({
        main_map
    })

    # countryName <- reactive(input$navbar)
    countryName <- COUNTRY
    themeName <- reactive(input$theme_selector)
    popName <- reactive(input$pop_selector)
    pm25_rank_order <- reactive(input$select_pm25_rank_order)
    # tabs_viewType <- reactive(input$tabs_viewType)
    tabs_Ranking_viewType <- reactive(input$tabs_Ranking_viewType)
    # brk_aq <- reactive(input$brk_selector_aq)
    # brk_pm <- reactive(input$brk_selector_pm)
    # number <- reactive(input$number_selector)

    observe({
        message("#------------#")
        # message(countryName())
        message(themeName())
        message(popName())
        message("#------------#")
    })

    ##### MAP ######
    
    leafletProxy("main_map") %>%
      addMap_boundary(countryName = COUNTRY) %>% 
      addMapPane("selected city", zIndex = 480) %>% 
      addMapPane("boundary", zIndex=470) %>% # 最上
      addMapPane("theme_pm25", zIndex=430) %>% # 最上
      addMapPane("theme_AQstation", zIndex = 420) %>% #中間 
      addMapPane("pop", zIndex=410) %>% #最下
      addMap_popName(countryName=countryName, popName="all")


    observeEvent(themeName(), {
        themeName = themeName()
        # themeName = "AQ Station"
        
        country_boundary_layer_name = LAYER_BOUNDARY_NAME
        country_theme_layer_name = paste0(LAYER_THEME_NAME, themeName)
        country_pop_layer_name = LAYER_POP_NAME

        leafletProxy("main_map") %>%
            ## main_map %>%
            addMap_theme(themeName=themeName, countryName = countryName) %>%
            addLayersControl(
                baseGroups = BASE_GROUPS,
                overlayGroups = c(country_theme_layer_name, 
                                  country_boundary_layer_name
                                  , country_pop_layer_name
                                  ),
                options = layersControlOptions(collapsed = TRUE)
            ) 

        output$ui_desc <- renderUI({
          
          if(themeName=="AQ Station"){
            desc = wellPanel(
              h3("AQ station accessibility analysis"),
              p("Identify the proportion of people who have access to locally relevant AQ data. Comparison is made between the proximity of AQ stations to people of different population groups. The proportions of the populations who live within 5 km (green), 10 km (orange) ,25 km (red) and over 25 km (purple) of AQ stations are provided.")
            )
          }
          if(themeName=="PM2.5"){
            desc = wellPanel(
              h3("PM2.5 exposure analysis"),
              p("Identify the proportion of people who are exposed to various concentration level. The current WHO air quality guideline for annual mean concentrations of PM2.5 is 5 µg/m3. Exceedance of this guideline is associated with important risks to public health. Four levels are categorized  1.meet the WHO guideline (Green), 2. exceed no more than five times(orange),  3. exceed between five and ten times (red),  4. exceed more than ten times(purple).")
            )
          }
          return(desc)
        })
        
    })
    
    observeEvent(popName(), {
      # countryName = countryName()
      popName = popName()

      leafletProxy("main_map") %>%
        clearGroup(LAYER_POP_NAME) %>% 
        # removeControl() %>% 
        addMap_popName(countryName = countryName, popName = popName) 
      
    })
    
    ##### Cities Rank ######
    observeEvent({
      themeName()
      popName()
      pm25_rank_order()
      1
    }, {
      # countryName = countryName()
      themeName=themeName()
      popName = popName()
      
      
      # popName = "pregs"
      if(themeName=="AQ Station"){
        orderfield = "group_a_prec"
      }
      if(themeName=="PM2.5"){
        orderfield = pm25_rank_order()
        #orderfield = "group_c_prec"
      }
      
      
      
      rankPlotData = getRankPlotData(countryName, themeName=themeName, popName=popName)
      #rankPlotData = getRankPlotData(countryName, themeName="PM2.5", popName="all")
      
      
      
      output$rank_stacked_chart <- renderPlotly({
        if(nrow(rankPlotData)>0){
          drawStackedChart(rankPlotData, orderfield, themeName)
        }
      })
      
      # output$rank_table <- DT::renderDataTable({
      #   d = getRankTable(rankPlotData, themeName) %>% dplyr::select(-ID)
      #   field_format_comma = names(d) %>% .[grep("#",.)]
      #   field_format_perc = names(d) %>% .[grep("%",.)]
      #   
      #   DT::datatable(d, 
      #                 option = list(
      #                   autoWidth = TRUE,
      #                   select = list(style = 'os', items = 'row'),
      #                   deferRender = TRUE, 
      #                   scrollY = "40vh", scrollX=500 , scroller = TRUE,
      #                   fixedColumns = list(leftColumns = 1)
      #                 ),
      #                 rownames = FALSE,
      #                 extensions = c("Scroller", "Select", "FixedColumns"),
      #                 selection = 'none'
      #     ) %>% 
      #     formatCurrency(columns = field_format_comma, currency = "", digits=0, interval = 3, mark = ",") %>% 
      #     formatPercentage(columns = field_format_perc, digits=2)
      # }, server = FALSE
      # )
      
          ####### Select City in Table #######
          # observeEvent(input$rank_table_rows_selected, {
          #   rowID = input$rank_table_rows_selected
          #   message(rowID)
          #   
          #   if(!is.null(row)){
          #     bound_id = getRankTable(rankPlotData, themeName) %>% .[rowID,] %>% pull(ID)  
          #     message(bound_id)
          #     
          #     leafletProxy("main_map") %>%
          #       cleanMap_selectCity() %>%
          #       addMap_selectCity(countryName, bound_id)
          #   }
          #   
          # })
      
    })
    
    # observeEvent(input$btn_cleanMap, {
    #   leafletProxy("main_map") %>%
    #     cleanMap_selectCity()
    # })
    
    # observeEvent({
    #   tabs_viewType()
    #   tabs_Ranking_viewType()
    #   1
    # }, {
    #   leafletProxy("main_map") %>%
    #     cleanMap_selectCity()  
    #   
    #   if(tabs_Ranking_viewType()!="Table"){
    #     leafletProxy("main_map") %>%
    #       cleanMap_selectCity()  
    #   }
    #   
    # })
    
    
    
    ##### Inspect City ######
    observeEvent({
      input$main_map_shape_click
      popName()
      1
      }, {
        bound_id = input$main_map_shape_click$id
        #bound_id = "IND.11.25_1"
        message(bound_id)
        # countryName = countryName()
        themeName = themeName()
        popName = popName()
        
        # 出錯 IND.7.26_1
        # IND.7.13_1
        # IND.29.20_1
        # IND.34.55_1
        
        
        if(themeName=="AQ Station"){
          data = getStationData(countryName)
          field="station"
        }else if(themeName =="PM2.5"){
          data = getPM25Data(countryName)
          field = "pm25"
        }
        
        tryCatch({
          this_data = data %>% dplyr::filter(get(ID)==bound_id)
          
          output$ui_city_situaion <- renderUI({
            generateUI_city_situation(this_data, field, popName)
          })  
        }, error = function(e){
          message("NO RESULT!!")
          
        output$ui_city_situaion <- renderUI({
          h3("Please select area from the map")
        })  
        
      })
      
      
      
      tryCatch({
        rankPlotData = getRankPlotData(countryName, themeName=themeName, popName=popName)
        
        output$plot_city_propotion <- renderPlotly({
          drawRankChart_city(rankPlotData, bound_id, themeName = themeName)  
        })  
      }, error = function(e){
        message("NO RESULT!!")
        
        output$plot_city_propotion <- renderPlotly({
          NULL
        })  
        
      })
      
      
      
      
      
      
    })
    
    

    
})