
getStationData = function(countryName){
  readRDS(paste0("data/",countryName,"/station_data_L",BOUND_LV,".rds"))
}

getPM25Data = function(countryName){
  readRDS(paste0("data/",countryName,"/pm25_data_L",BOUND_LV,".rds"))  
}

getBoundary = function(countryName){
  readRDS(paste0("data/",countryName,"/border_LV",BOUND_LV,".rds"))  
}

getStation = function(countryName){
  readRDS(paste0("data/",countryName,"/station.rds"))  
}

getPM25Layer = function(countryName){
  raster(paste0("data/",countryName,"/pm25.tif"))  
}

getPopNameLayer = function(countryName, popName=c("pop", "pregs", "old", "child")){
  raster(paste0("data/",countryName,"/pop_",popName,".tif"))  
}

getPopNameLayerBrk = function(countryName, popName=c("all", "pregs", "old", "child")){
  # readRDS(paste0("data/",countryName,"/pop_",popName,"_brk.rds"))
  if(countryName=="Colombia"){
    if(popName=="all"){
      brks = c(0, 100, 500, 1000, 2000, 3000, Inf)
    }
    if(popName=="old"){
      brks = c(0, 10, 50,100,200,300, Inf)
    }
    if(popName=="pregs"){
      brks = c(0, 5,10,20,30,40, Inf)
    }
    if(popName=="child"){
      brks = c(0, 10,50,100,200,300, Inf)
    }  
  }
  
  if(countryName=="India"){
    if(popName=="all"){
      brks = c(0, 5000,10000,15000,20000,25000, Inf)
    }
    if(popName=="old"){
      brks = c(0,300,600,900,1200,1500, Inf)
    }
    if(popName=="pregs"){
      brks = c(0, 200,400,600,800,1000, Inf)
    }
    if(popName=="child"){
      brks = c(0, 100,200,300,400,500, Inf)
    }  
  }
  
  if(countryName=="Indonesia"){
    if(popName=="all"){
      brks = c(0, 500,1000,5000,10000,30000, Inf)
    }
    if(popName=="old"){
      brks = c(0,10,50,100,200,300, Inf)
    }
    if(popName=="pregs"){
      brks = c(0, 10,50,100,500,1000, Inf)
    }
    if(popName=="child"){
      brks = c(0, 10,50,100,250,500, Inf)
    }  
  }
  
  if(countryName=="Malaysia"){
    if(popName=="all"){
      brks = c(0, 100,500,1000,5000,10000, Inf)
    }
    if(popName=="old"){
      brks = c(0,10,50,100,500,1000, Inf)
    }
    if(popName=="pregs"){
      brks = c(0,10,50,100,300,500, Inf)
    }
    if(popName=="child"){
      brks = c(0, 10, 50, 100, 500, 1000, Inf)
    }  
  }
  
  if(countryName=="Philippines"){
    if(popName=="all"){
      brks = c(0, 1000, 3000, 5000, 10000, 15000, Inf)
    }
    if(popName=="old"){
      brks = c(0, 50, 100, 500, 1000, 2000, Inf)
    }
    if(popName=="pregs"){
      brks = c(0, 100, 500, 1000, 2000, 3000, Inf)
    }
    if(popName=="child"){
      brks = c(0, 100, 300, 500, 1000, 5000, Inf)
    }  
  }
  
  if(countryName=="Thailand"){
    if(popName=="all"){
      brks = c(0, 1000, 5000, 10000, 30000, 50000, Inf)
    }
    if(popName=="old"){
      brks = c(0, 100, 500, 1000, 3000, 5000, Inf)
    }
    if(popName=="pregs"){
      brks = c(0, 10, 100, 500, 1000, 2000, Inf)
    }
    if(popName=="child"){
      brks = c(0, 100, 300, 500, 800, 1000, Inf)
    }  
  }
  
  if(countryName=="Turkey"){
    if(popName=="all"){
      brks = c(0, 100, 1000, 5000, 10000, 50000, Inf)
    }
    if(popName=="old"){
      brks = c(0, 10, 50, 100, 500, 1000, Inf)
    }
    if(popName=="pregs"){
      brks = c(0, 50, 100, 500, 1000, 5000, Inf)
    }
    if(popName=="child"){
      brks = c(0, 10, 50, 100, 200, 500, Inf)
    }  
  }
  
  if(countryName=="SouthAfrica"){
    if(popName=="all"){
      brks = c(0, 10, 100, 500, 1000, 5000, Inf)
    }
    if(popName=="old"){
      brks = c(0, 5, 10, 50, 100, 500, Inf)
    }
    if(popName=="pregs"){
      brks = c(0, 5, 10, 50, 100, 500, Inf)
    }
    if(popName=="child"){
      brks = c(0, 10, 50, 100, 300, 500, Inf)
    }  
  }
  
  return(brks)
}

addMap_boundary = function(map, countryName){
  boundary = getBoundary(countryName)
  layerName = LAYER_BOUNDARY_NAME
  labels <- paste0("<h4 style='text-align: center;'>",boundary[[NAME]],"</h4>") %>% lapply(htmltools::HTML)
  
  map %>%
    # main_map %>%
    addPolygons(
      data = boundary,
      layerId = ~get(ID),
      
      ###### no hide ######
      # weight = 1,
      # opacity = 1,
      # color = "#CDCDCD",
      # dashArray = "3",
      # fillOpacity = 0,
      
      ###### hide ######
      stroke = FALSE,
      fill = TRUE,
      fillOpacity = 0,
      dashArray = "3",
      highlightOptions = highlightOptions(
        weight = 5,
        color = "red",
        dashArray = "",
        bringToFront = TRUE),
      ######
      label = labels,
      labelOptions = labelOptions(
        direction = "top",
        style = list(
          "font-weight" = "900",
          "font-size" = "20px"
        )
      ), 
      group = layerName
      # ,options = pathOptions(pane = "boundary")
    ) 
  
}

# bound_id = "IND.29.4_1"
addMap_selectCity = function(map, countryName, bound_id){
  bound = getBoundary(countryName) %>% filter(get(ID)==bound_id)
  layerName = "selected city"
  labels <- paste0("<h4 style='text-align: center;'>",bound[[NAME]],"</h4>") %>% lapply(htmltools::HTML)
  
  if(nrow(bound)!=0){
    map %>%
      # main_map %>% 
      addPolygons(
        data = bound, 
        weight = 5,
        color = "#FF00C9",
        fillOpacity = 0,
        group = layerName,
        label = labels,
        labelOptions = labelOptions(
          noHide = T, 
          direction = "top",
          style = list(
            "font-weight" = "900",
            "font-size" = "20px"
          )
          
        ), 
        options = pathOptions(pane = layerName)
      )
  }
}

cleanMap_selectCity = function(map){
  map %>% 
    # main_map %>% 
    clearGroup("selected city")
}

addMap_popName = function(map, countryName, popName){
  popRaster = getPopNameLayer(countryName, popName)
  # layerName = paste0(countryName, " Population")
  group_name = LAYER_POP_NAME
  group_id = paste0(LAYER_POP_NAME, "_layerId")
  # country_pop_layer_name = LAYER_POP_NAME
  brks = getPopNameLayerBrk(countryName, popName)
  
  labels = c(
    paste0(brks[1], " - ", brks[2]),
    paste0(brks[2], " - ", brks[3]),
    paste0(brks[3], " - ", brks[4]),
    paste0(brks[4], " - ", brks[5]),
    paste0(brks[5], " - ", brks[6]),
    paste0("> ", brks[6])
             )
  
  if(popName=="all"){
    layerTitle = paste0(countryName, " All Population")
  }
  if(popName=="old"){
    layerTitle = paste0(countryName, " Older adults (over 65)")
  }
  if(popName=="pregs"){
    layerTitle = paste0(countryName, " Pregnant people")
  }
  if(popName=="child"){
    layerTitle = paste0(countryName, " Infants (under 5)")
  }
  
  pal <- colorBin(palette = c('#fafafa','#c9c9c9','#989898','#676767','#363636','#050505'), bins = brks, pretty = TRUE,
                  domain=brks, na.color = "transparent")
  
  
  map %>%
    # main_map %>%
    addRasterImage(popRaster, colors = pal, opacity = 0.4, group = group_name , options = tileOptions(pane = "pop")
    ) %>%
    addLegend(pal=pal, values = brks, title = layerTitle, position="bottomright", 
              group = group_name 
              ,layerId = group_id
              ,labFormat = function(type, cuts, p) {  paste0(labels) }
    )
  
  
}

addMap_AQ_station = function(map, countryName){
  station = getStation(countryName) #%>% mutate(value = 1, label = "AQ Station")
  layerName = "AQ Station"
  layerId = paste0(countryName, "_layer_legend_AQstation")
  
  map %>%
    # main_map %>%
    addCircles(data = station,
               color = "red",
               group = layerName
               ,options = pathOptions(pane = "theme_AQstation")
    ) %>% 
    addLegend(
      colors = "red",
      position = "bottomleft",
      group = layerName, layerId = layerId,
      labels = "AQ Station"
    )
}

addMap_pm25 = function(map, countryName){
  pm25 = getPM25Layer(countryName)
  layerName = "PM2.5"
  layerId = paste0(countryName, "_layer_legend_pm25")
  
  
  
  if(countryName=="India"){
    brks = c(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 75, 100, Inf)
    pal = colorBin(palette = COLOR_BRK_map_india, bins = brks, domain = brks, na.color="transparent")
    labels = c(
      paste0(brks[1], " - ", brks[2]),
      paste0(brks[2], " - ", brks[3]),
      paste0(brks[3], " - ", brks[4]),
      paste0(brks[4], " - ", brks[5]),
      paste0(brks[5], " - ", brks[6]),
      paste0(brks[6], " - ", brks[7]),
      paste0(brks[7], " - ", brks[8]),
      paste0(brks[8], " - ", brks[9]),
      paste0(brks[9], " - ", brks[10]),
      paste0(brks[10], " - ", brks[11]),
      paste0(brks[11], " - ", brks[12]),
      paste0(brks[12], " - ", brks[13]),
      paste0("> ", brks[13])
    )
  }else{
    brks = c(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, Inf)
    pal = colorBin(palette = COLOR_BRK_map, bins = brks, domain = brks, na.color="transparent")  
    labels = c(
      paste0(brks[1], " - ", brks[2]),
      paste0(brks[2], " - ", brks[3]),
      paste0(brks[3], " - ", brks[4]),
      paste0(brks[4], " - ", brks[5]),
      paste0(brks[5], " - ", brks[6]),
      paste0(brks[6], " - ", brks[7]),
      paste0(brks[7], " - ", brks[8]),
      paste0(brks[8], " - ", brks[9]),
      paste0(brks[9], " - ", brks[10]),
      paste0(brks[10], " - ", brks[11]),
      paste0("> ", brks[11])
      )
  }
  
  
  map %>%
    # main_map %>%
    addRasterImage(pm25, colors = pal, opacity = 0.6, group = layerName #, options = tileOptions(pane = "theme_pm25")
    ) %>% 
    addLegend(pal=pal, values = brks, 
              title = "PM<sub>2.5</sub> (??g/m<sup>3</sup>)",
              position="bottomleft", layerId = layerId
              ,labFormat = function(type, cuts, p) {  paste0(labels) }
              )
}


clearMap_theme = function(map, countryName){
  theme_layer_names = c("AQ Station", "PM2.5")
  
  map %>% 
    removeControl(paste0(countryName, "_layer_legend_pm25")) %>% 
    removeControl(paste0(countryName, "_layer_legend_AQstation")) %>% 
    clearGroup(theme_layer_names)
  
}

addMap_theme = function(map, themeName, countryName){
  if(themeName=="AQ Station"){
    map %>% 
      clearMap_theme(countryName) %>% 
      addMap_AQ_station(countryName)
  }else if(themeName=="PM2.5"){
    map %>% 
      clearMap_theme(countryName) %>% 
      addMap_pm25(countryName)
  }
}


### rank
# themeName = "PM2.5"
# popName = "all"
getRankPlotData = function(countryName, themeName, popName){
  if(themeName=="AQ Station"){
    d = getStationData(countryName)
    fieldName = "station"
  }else if(themeName =="PM2.5"){
    d = getPM25Data(countryName)
    fieldName = "pm25"
  }


  field_selector = paste0(fieldName, "_", popName)
  group_all = paste0(fieldName, "_", popName, "_all")
  brks = c("A", "B", "C")
  group_brks = paste0("group", "_", brks)

  # ????????????????????????????????????
  # ???????????? Station ??? PM2.5 ??? break point ???????????????
  d %<>% dplyr::select(NAME, ID, group_all, starts_with(field_selector))
  names(d) <- c(NAME, ID, "group_all", group_brks)

  d %<>% mutate(across(group_brks, ~round(.x/group_all, 6), .names = "{.col}_prec"))


  if(themeName=="AQ Station"){
    d %<>% mutate(
      group_a_prec = group_A_prec,
      group_ab_prec = group_B_prec-group_A_prec,
      group_bc_prec = group_C_prec-group_B_prec,
      group_c_prec = 1-group_C_prec
    )

  }
  if(themeName=="PM2.5"){

    #### 0824 updated ####
    if(themeName=="PM2.5" & countryName %in% c("Malaysia", "Philippines", "Thailand", "Indonesia", "Turkey")){
      message("FIX group_a_prec PROBLEM!!!")
      d %<>% mutate(
        group_a_prec = 0,
        group_ab_prec = (1-group_A_prec)+group_A_prec-group_B_prec,
        group_bc_prec = group_B_prec-group_C_prec,
        group_c_prec = group_C_prec
      )
    }

    d %<>% mutate(
      group_a_prec = 1-group_A_prec,
      group_ab_prec = group_A_prec-group_B_prec,
      group_bc_prec = group_B_prec-group_C_prec,
      group_c_prec = group_C_prec
    )
  }


  d %<>% mutate(across(c("group_a_prec", "group_ab_prec", "group_bc_prec", "group_c_prec"), ~round(.x * group_all, 0), .names ="{.col}_num")) %>%
    rename_if(grepl("_num", names(.)), ~gsub("_prec","",.x)) %>%
    dplyr::select(NAME, ID, THEME_BREAK_TABLE %>% dplyr::filter(theme==themeName) %>% pull(var)) %>%  #reorder the columns
    replace(is.na(.), 0)

  return(d)
}


# rankPlotData = getRankPlotData(countryName, themeName="PM2.5", popName="all")
# orderfield = "group_c_prec"
# themeName = "PM2.5"
drawStackedChart = function(rankPlotData, orderfield, themeName){
  
  
  countryAvg =
    rankPlotData %>% 
    mutate_at(.vars = vars(group_all, ends_with("_num")), .funs = sum) %>% 
    dplyr::select_at(.vars = vars(group_all, ends_with("_num"))) %>% distinct() %>% 
    mutate(across(ends_with("_num"), ~round(.x/group_all,6), .names = "{.col}_prec")) %>% 
    rename_if(grepl("_num", names(.)), ~gsub("_num","",.x)) %>% 
    mutate( name = "COUNTRY AVG") %>% 
    mutate(across(ends_with("prec"), ~.x*100)) %>% 
    mutate(across(ends_with("prec"), ~round(.x,2))) 
  
  # if(orderfield=="group_c_prec" & countryAvg$group_c_prec==0) orderfield = "group_bc_prec"
  # if(orderfield=="group_a_prec" & countryAvg$group_a_prec==0) orderfield = "group_ab_prec"
  
  if(orderfield == "group_c_prec"){
    d = rankPlotData %>% arrange(
      desc(group_c_prec),
      desc(group_bc_prec),
      desc(group_ab_prec),
      desc(group_a_prec)
    )
  }else{
    d = rankPlotData %>% arrange(
      desc(group_a_prec),
      desc(group_ab_prec),
      desc(group_bc_prec),
      desc(group_c_prec)
    )
  }
  ###################
  # d = rankPlotData %>% arrange(desc(group_all))
  ###################
  
  d %<>% head(15) %>% 
    mutate(across(ends_with("prec"), ~.x*100)) %>% 
    mutate(across(ends_with("prec"), ~round(.x,2))) %>% 
    rename(name = !!NAME)
  
  tb = THEME_BREAK_TABLE %>% filter(theme==themeName) %>% dplyr::select(-theme)
  
  p_avg = 
    plot_ly(countryAvg, y=~name, x=~group_a_prec, type='bar', 
            name = filter(tb, var=="group_a_prec")%>% pull(varName), 
            text = filter(tb, var=="group_a_prec")%>% pull(varName), 
            hoverinfo = "x+y",
            hovertemplate = "%{y}: %{x}%",
            marker = list(color = COLOR_BRK_data[1])) %>% 
    add_trace(x=~group_ab_prec, 
              name = filter(tb, var=="group_ab_prec")%>% pull(varName), 
              text = filter(tb, var=="group_ab_prec")%>% pull(varName), 
              hoverinfo = "x+y",
              hovertemplate = "%{y}: %{x}%",
              marker = list(color = COLOR_BRK_data[2])) %>% 
    add_trace(x=~group_bc_prec, 
              name = filter(tb, var=="group_bc_prec")%>% pull(varName), 
              text = filter(tb, var=="group_bc_prec")%>% pull(varName), 
              hoverinfo = "x+y",
              hovertemplate = "%{y}: %{x}%",
              marker = list(color = COLOR_BRK_data[3])) %>% 
    add_trace(x=~group_c_prec, 
              name = filter(tb, var=="group_c_prec")%>% pull(varName), 
              text = filter(tb, var=="group_c_prec")%>% pull(varName), 
              hoverinfo = "x+y",
              hovertemplate = "%{y}: %{x}%",
              marker = list(color = COLOR_BRK_data[4])) %>% 
    layout(barmode = 'stack', showlegend = FALSE,
           xaxis = list(title = "%"),
           yaxis = list(title = "", categoryorder = "array", categoryarray = rev(d$name)
                        ,ticksuffix = "  "
                        )
    )
  
  
  ###
  p = plot_ly(d, y=~name, x=~group_a_prec, type='bar', 
              name = filter(tb, var=="group_a_prec")%>% pull(varName), 
              text = filter(tb, var=="group_a_prec")%>% pull(varName), 
              hoverinfo = "x+y",
              hovertemplate = "%{y}: %{x}%",
              marker = list(color = COLOR_BRK_data[1])) %>% 
    add_trace(x=~group_ab_prec, 
              name = filter(tb, var=="group_ab_prec")%>% pull(varName), 
              text = filter(tb, var=="group_ab_prec")%>% pull(varName), 
              hoverinfo = "x+y",
              hovertemplate = "%{y}: %{x}%",
              marker = list(color = COLOR_BRK_data[2])) %>% 
    add_trace(x=~group_bc_prec, 
              name = filter(tb, var=="group_bc_prec")%>% pull(varName), 
              text = filter(tb, var=="group_bc_prec")%>% pull(varName), 
              hoverinfo = "x+y",
              hovertemplate = "%{y}: %{x}%",
              marker = list(color = COLOR_BRK_data[3])) %>% 
    add_trace(x=~group_c_prec, 
              name = filter(tb, var=="group_c_prec")%>% pull(varName), 
              text = filter(tb, var=="group_c_prec")%>% pull(varName), 
              hoverinfo = "x+y",
              hovertemplate = "%{y}: %{x}%",
              marker = list(color = COLOR_BRK_data[4])) %>% 
    layout(barmode = 'stack', showlegend = FALSE,
           xaxis = list(title = "%"),
           yaxis = list(title = "", categoryorder = "array", categoryarray = rev(d$name)
                        ,ticksuffix = "  "
                        )
    )
  
  subplot(p_avg, p, nrows=2, shareX = TRUE, heights = c(0.1, 0.9),
          margin = 0.005
  ) %>% config(displayModeBar = FALSE)
  

}


getRankTable = function(rankPlotData, themeName){
  
  
  field_show = c(NAME, ID,"group_all",
                 "group_a_num", "group_ab_num", "group_bc_num", "group_c_num",
                 "group_a_prec", "group_ab_prec", "group_bc_prec", "group_c_prec")
  d = rankPlotData %>% dplyr::select(!!field_show) %>% arrange(desc(group_all))
  tb = THEME_BREAK_TABLE %>% filter(theme==themeName) %>% dplyr::select(-theme) %>% 
    filter(var%in%field_show)
  names(d) <- c("name", ID, tb %>% pull(varName))
  
  
  d
}

#### City Inspect ####
# d = getStationData(countryName)

# generateUI_city_situation = function(this_data, field, popName){
#   
#   field_all = paste0(field, "_",popName,"_all")
#   
#   generatePopRow = function(this_data, popName, field_all){
#     numberFormat = function(num){
#       formatC(num, format="f", big.mark=",", digits=0)
#     }
#     
#     if(popName=="all"){
#       title = "Total Population:"
#     }
#     if(popName=="child"){
#       title = "Total Infant (0-4):"
#     }
#     if(popName=="old"){
#       title = "Total Elderlies (65+):"
#     }
#     if(popName=="pregs"){
#       title = "Total Pregnant Women:"
#     }
#     
#     
#     HTML('<tr style="height: 18px;">
#       <td style="width: 50%; height: 18px;">', title,'</td>
#       <td style="width: 50%; height: 18px;">', this_data %>% pull(field_all) %>% numberFormat,'</td>
#       </tr>')
#   }
#   
#   
#   div(class="city_situation",
#       h3(paste0(this_data[[NAME]])),
#       hr(),
#       HTML('
#       <table style="height: 72px; width: 50%; border-collapse: collapse;" border="0">
#       <tbody>
#       ',generatePopRow(this_data, popName, field_all),'
#       </tbody>
#       </table>
#       ')
#   )
#   
# }


drawRankChart_city = function(rankPlotData, bound_id, themeName){
  
  tb = THEME_BREAK_TABLE %>% filter(theme==themeName) %>% dplyr::select(-theme)
  
  dt = rankPlotData %>% filter(get(ID)==bound_id) %>% 
    tidyr::gather("var", "value") %>% 
    filter(var%in%c("group_a_prec", "group_ab_prec", "group_bc_prec", "group_c_prec")) %>% 
    mutate(value = as.numeric(value) %>% "*"(100) %>% round(2)) %>% 
    left_join(., tb, by="var")
  
  
  plot_ly(dt, y = ~varName, x=~value, type="bar", 
          text = ~paste0(value, "%"), 
          textposition = 'auto', 
          hoverinfo = "y",
          hoverlabel = list(font = list(size=18)),
          marker = list(color=COLOR_BRK_data)
  ) %>% 
    layout(
      font = list(size=18),
      yaxis=list(title="", categoryorder = "array", categoryarray = rev(dt$varName), 
                 showticklabels = FALSE
      ), 
      xaxis = list(title = "%")) %>% 
    config(displayModeBar = FALSE)
  
}
