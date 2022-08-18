library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(leaflet)
setwd(choose.dir())
getwd()

rainfall=read.csv("rainfall_area-wt_sd_1901-2015.csv")
mean_temp=read.csv("Mean_Temp_IMD_2017.csv")
min_temp=read.csv("Min_Temp_IMD_2017.csv")
max_temp=read.csv("Max_Temp_IMD_2017.csv")
cities=read.csv("GlobalLandTemperaturesByMajorCity.csv")

View(min_temp)


dataset=c("Min Temperature for 117 years"="min_temp",
          "Max Temperature for 117 years"="max_temp",
          "Average Temperature for 117 years"="mean_temp",
          "Rainfall for 115 years"="rainfall")

subdivision=rainfall %>% c(rainfall %>% group_by(SUBDIVISION) %>% summarise(mean=mean('ANNUAL'),na.rm=FALSE) %>% select(SUBDIVISION))

ui=dashboardPage(dashboardHeader(title = "Climate of India"),
                 dashboardSidebar(
                   sidebarMenu(
                     menuItem(text = "Maps",tabName = "map",icon=icon("map-marker"),
                              menuSubItem(text="Climate",tabName="climate",icon=icon("fas fa-globe-asia"))),
                     
                     menuItem(text = "Graphs",tabName = "graph",icon=icon("fas fa-signal"),
                              menuSubItem(text = "Barplot",tabName = "barplot",icon = icon("bar-chart-o")),
                              menuSubItem(text = "ScatterPlot",tabName = "scatter",icon = icon("stats",lib="glyphicon")),
                              menuSubItem(text = "LinePlot",tabName = "lineplot",icon = icon("fas fa-chart-line")),
                              menuSubItem(text = 'DensityPlot',tabName = 'density'),
                         #     menuSubItem(text = 'ViolinPlot',tabName = 'violinn'),
                               menuSubItem(text = 'BoxPlot',tabName = 'boxplot'),
                              menuSubItem(text = 'Histogram',tabName = 'histo'),
                              ),
                     menuItem(text = "Tables",tabName = "table",icon = icon("table")),
                     
                     menuItem(text="Table variations",tabName = "filter",
                     menuSubItem(text="Table by months",tabName = "f1"),
                     menuSubItem(text="Table by seasons",tabName = "f2")),
                     
                     
                     menuItem(text="more variations",tabName = "filter2",
                              menuSubItem(text = "highest rainfall",tabName = "highest"))
                     
                     
                     
                     
                   )
                 ),
                 dashboardBody(
                   tabItems(
                     tabItem(tabName="climate",icon=icon("cloud-sun-rain"),p("Temperature"),
                             fluidRow(box(height=30,width=15,title = "Temperature Map of India",leafletOutput("temperature"), solidHeader = TRUE))),
                     
                     
                     tabItem(tabName = "barplot",icon=icon("signal",lib="glyphicon"),p("Barplot"),
                             fluidRow(tabBox(title = "Barplot",tabPanel(title="Monthly Graph",plotOutput("barmonth")),
                                             tabPanel(title="Seasonly Graph",plotOutput("barseason")),
                                             tabPanel(title="Annual Graph",plotOutput("barannual"))),
                                      box(title = "Input For the Graph",
                                          selectInput(inputId = "climatetype",label = "Select the type which you want the graph",
                                                      choices = dataset,)),
                                      tabBox(
                                        tabPanel(selectInput(inputId = "month",label = "Select the Month",
                                                             choices = c(colnames(rainfall[,3:14])),selected = "JAN")),
                                        tabPanel(selectInput(inputId = "annual",label = "Annual",
                                                             choices = c("ANNUAL"),selected = "ANNUAL")),
                                        tabPanel(selectInput(inputId = "seasonal",label = "Select the Season",
                                                             choices = c(colnames(rainfall[,16:19])))),
                                        tabPanel(selectInput(inputId = "subdiv",label = "Select subdivision(only for rainfall)",
                                                             choices = c(rainfall %>% group_by(SUBDIVISION) %>% summarise(mean=mean('ANNUAL'),na.rm=FALSE) %>% select(SUBDIVISION))
                                        ))))),
                     
                     
                     tabItem(tabName = "scatter",icon=icon("stats",lib="glyphicon"),p("Scatterplot"),
                             fluidRow(tabBox(title = "Scatterplot",tabPanel(title="Monthly Graph",plotOutput("scattermonth")),
                                             tabPanel(title="Seasonly Graph",plotOutput("scatterseason")),
                                             tabPanel(title="Annual Graph",plotOutput("scatterannual"))),
                                      box(title = "Input For the Graph",
                                          selectInput(inputId = "climatetype2",label = "Select the type which you want the graph",
                                                      choices = dataset,)),
                                      tabBox(
                                        tabPanel(selectInput(inputId = "month2",label = "Select the Month",
                                                             choices = c(colnames(rainfall[,3:14])),selected = "JAN")),
                                        tabPanel(selectInput(inputId = "annual2",label = "Annual",
                                                             choices = c("ANNUAL"),selected = "ANNUAL")),
                                        tabPanel(selectInput(inputId = "seasonal2",label = "Select the Season",
                                                             choices = c(colnames(rainfall[,16:19])))),
                                        tabPanel(selectInput(inputId = "subdiv2",label = "Select subdivision(only for rainfall)",
                                                             choices = c(rainfall %>% group_by(SUBDIVISION) %>% summarise(mean=mean('ANNUAL'),na.rm=FALSE) %>% select(SUBDIVISION))
                                        ))))),
                     
                     
                     tabItem(tabName = "lineplot",icon=icon("chart-line"),p("LinePlot"),
                             fluidRow(tabBox(title = "Line Plot",tabPanel(title="Monthly Graph",plotOutput("linemonth")),
                                             tabPanel(title="Seasonly Graph",plotOutput("lineseason")),
                                             tabPanel(title="Annual Graph",plotOutput("lineannual"))),
                                      box(title = "Input For the Graph",
                                          selectInput(inputId = "climatetype3",label = "Select the type which you want the graph",
                                                      choices = dataset,)),
                                      tabBox(
                                        tabPanel(selectInput(inputId = "month3",label = "Select the Month",
                                                             choices = c(colnames(rainfall[,3:14])),selected = "JAN")),
                                        tabPanel(selectInput(inputId = "annual3",label = "Annual",
                                                             choices = c("ANNUAL"),selected = "ANNUAL")),
                                        tabPanel(selectInput(inputId = "seasonal3",label = "Select the Season",
                                                             choices = c(colnames(rainfall[,16:19])))),
                                        tabPanel(selectInput(inputId = "subdiv3",label = "Select subdivision(only for rainfall)",
                                                             choices = c(rainfall %>% group_by(SUBDIVISION) %>% summarise(mean=mean('ANNUAL'),na.rm=FALSE) %>% select(SUBDIVISION))
                                        ))))),
                     
                     
                     tabItem(tabName = "density",icon=icon("density"),p("DensityGraph"),
                             fluidRow(tabBox(title = "Density Plot",tabPanel(title="Monthly Graph",plotOutput("densitymonth")),
                                             tabPanel(title="Seasonly Graph",plotOutput("densityseason")),
                                             tabPanel(title="Annual Graph",plotOutput("densityannual"))),
                                      
                                      box(title = "Input for Graph",
                                          
                                          selectInput(inputId = "climatetype4",label = "Select the Year for which you want the graph",
                                                      choices =dataset,)),
                                      tabBox(         
                                        tabPanel(selectInput(inputId = "month4",label = "Select the Month",
                                                             choices = c(colnames(rainfall[,3:14])),selected = "JAN")),
                                        tabPanel(selectInput(inputId = "annual4",label = "Annual",
                                                             choices = c("ANNUAL"),selected = "ANNUAL")),
                                        tabPanel(selectInput(inputId = "seasonal4",label = "Select the Season",
                                                             choices = c(colnames(rainfall[,16:19])))),
                                        tabPanel(selectInput(inputId = "subdiv44",label = "Select subdivision(only for rainfall)",
                                                             choices = c(rainfall %>% group_by(SUBDIVISION) %>% summarise(mean=mean('ANNUAL'),na.rm=FALSE) %>% select(SUBDIVISION))
                                        ))))),
                     
                     
                     tabItem(tabName = "histo",icon=icon("histogram"),p("Histogram"),
                             fluidRow(tabBox(title = "Histogram",tabPanel(title="Monthly Graph",plotOutput("histomonth")),
                                             tabPanel(title="Seasonly Graph",plotOutput("histoseason")),
                                             tabPanel(title="Annual Graph",plotOutput("histoannual"))),
                                      
                                      box(title = "Input for Graph",
                                          
                                          selectInput(inputId = "climatetype5",label = "Select the Year for which you want the graph",
                                                      choices =dataset,)),
                                      tabBox(         
                                        tabPanel(selectInput(inputId = "month5",label = "Select the Month",
                                                             choices = c(colnames(rainfall[,3:14])),selected = "JAN")),
                                        tabPanel(selectInput(inputId = "annual5",label = "Annual",
                                                             choices = c("ANNUAL"),selected = "ANNUAL")),
                                        tabPanel(selectInput(inputId = "seasonal5",label = "Select the Season",
                                                             choices = c(colnames(rainfall[,16:19])))),
                                        tabPanel(selectInput(inputId = "subdiv5",label = "Select subdivision(only for rainfall)",
                                                             choices = c(rainfall %>% group_by(SUBDIVISION) %>% summarise(mean=mean('ANNUAL'),na.rm=FALSE) %>% select(SUBDIVISION))
                                        ))))),
                     
                     
                     
                   tabItem(tabName = "boxplot",icon=icon("Boxplot"),p("Boxplot"),
                             fluidRow(tabBox(title = "Boxplot",tabPanel(title="Monthly Graph",plotOutput("boxmonth")),
                                             tabPanel(title="Seasonly Graph",plotOutput("boxseason")),
                                        tabPanel(title="Annual Graph",plotOutput("boxannual"))),
                                      
                                      box(title = "Input for Graph",
                                          
                                          selectInput(inputId = "climatetype6",label = "Select the Year for which you want the graph",
                                                      choices =dataset,)),
                                      tabBox(         
                                        tabPanel(selectInput(inputId = "month6",label = "Select the Month",
                                                             choices = c(colnames(rainfall[,3:14])),selected = "JAN")),
                                       tabPanel(selectInput(inputId = "annual6",label = "Annual",
                                                             choices = c("ANNUAL"),selected = "ANNUAL")),
                                        tabPanel(selectInput(inputId = "seasonal6",label = "Select the Season",
                                                             choices = c(colnames(rainfall[,16:19])))),
                                        tabPanel(selectInput(inputId = "subdiv6",label = "Select subdivision(only for rainfall)",
                                                             choices = c(rainfall %>% group_by(SUBDIVISION) %>% summarise(mean=mean('ANNUAL'),na.rm=FALSE) %>% select(SUBDIVISION))
                                        ))))),
                     
                     
                     
                     
                     tabItem(tabName = "table",icon=icon("table"),p("Table"),
                             fluidRow(column(width=12,
                                             box(title = "Select Inputs for table",
                                                 selectInput(inputId = "climatedim",label = "Select the Dimension of Climate",
                                                             choices = dataset),
                                                 selectInput(inputId = "yearno",label="Select the year no",
                                                             choices = c(min_temp[,'YEAR'])),
                                                 selectInput(inputId = "subdiv4",label = "Select the subdivision only for Rainfall",
                                                             choices = c(rainfall %>% group_by(SUBDIVISION) %>% summarise(mean=mean('ANNUAL'),na.rm=FALSE) %>% select(SUBDIVISION)),
                                                 )),
                                             box(title = "Table",width=20,tableOutput("tableoutput"),
                                                 tableOutput("tableout2"),
                                                 tableOutput("tableout3"))))),
                   
                   
                   
                   
                   tabItem(tabName = "f1",icon=icon("stats",lib="glyphicon"),p("Table Across Various Points"),
                           fluidRow(
                             selectInput(inputId="SI1",label="    Start Year",choices=sort(unique(min_temp$YEAR))),
                             selectInput(inputId="SI2",label="    Stop Year",choices=sort(unique(min_temp$YEAR))),
                             checkboxGroupInput(inputId = "ch1",label=h3("Select Months"),
                                                choices= c("January"="JAN","February"="FEB","March"="MAR","April"="APR","May"="MAY",
                                                           "June"="JUN","July"="JUL","August"="AUG","September"="SEP","October"="OCT","November"="NOV","December"="DEC","Annual"="ANNUAL"),selected = "JAN"),
                             mainPanel(tabsetPanel(
                               tabPanel("Min Temp Summary",verbatimTextOutput("summary1")),
                               tabPanel("Mean Temp Summary",verbatimTextOutput("summary2")),
                               tabPanel("Max Temp Summary",verbatimTextOutput("summary3"))
                             ))
                           )),
                   
                   
                   
                   tabItem(tabName = "f2",icon=icon("stats",lib="glyphicon"),p("Table Across Various Points"),
                           fluidRow(
                             selectInput(inputId="SI1",label="Start Year",choices=sort(unique(min_temp$YEAR))),
                             selectInput(inputId="SI2",label="Stop Year",choices=sort(unique(min_temp$YEAR))),
                             checkboxGroupInput(inputId = "ch3",label=h3("Select Months"),
                                                choices= c("January-February"=15,"March-May"=16,
                                                           "June-September"=17,"October-December"=18,"Annual"=14),selected =15),
                             mainPanel(tabsetPanel(
                               tabPanel("Min Temp Summary",verbatimTextOutput("summary4")),
                               tabPanel("Mean Temp Summary",verbatimTextOutput("summary5")),
                               tabPanel("Max Temp Summary",verbatimTextOutput("summary6"))
                             ))
                           )),
                   
                   
                   
                   
                   
                   
                   tabItem(text="Want to ask Queries ? ",tabName = "highest",
                           tabsetPanel(tabPanel(
                             fluidRow(box(sliderInput(inputId = "selyear",label = "Select the range of years",
                                                      min=rainfall[1,2],max = rainfall[nrow(rainfall),2],value = c(1967,1988))),
                                      box(sliderInput(inputId = "selmonth",label = "select the range of months",
                                                      min = 3,max=14,value = c(3,4))),
                                      box(tableOutput("result"))
                             )
                           ))),
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   )
                   
                   
                   
                   )
                 )



server=function(input,output){
  #  tablename=reactive({
  #   switch(input$climatetype)
  #})
  output$temperature=renderLeaflet({
    loc=cities %>% mutate(Long=as.numeric(gsub("[a-zA-Z]","",Longitude)),Latt=as.numeric(gsub("[a-zA-Z]","",Latitude)))
    
    x=loc %>% group_by(City) %>% summarise(AverageTemperature=mean(AverageTemperature,na.rm=TRUE),
                                           AverageTemperatureUncertainty=mean(AverageTemperatureUncertainty,na.rm=TRUE),
                                           Longitude=mean(Long,na.rm=TRUE),Latitude=mean(Latt,na.rm=TRUE))
    leaflet(data=x) %>% addTiles() %>% addMarkers(lat = x$Latitude,lng = x$Longitude,popup = (paste("AvgTemp = ",as.character(x$AverageTemperature),"\r\n","Avg Temp Uncertainity=",as.character(x$AverageTemperatureUncertainty))),label = as.character(x$City))
    
  })
  tb=reactive({
    get(input$climatetype)
  })
  tb2=reactive({get(input$climatetype2)})
  tb3=reactive({get(input$climatetype3)})
  tb4=reactive({get(input$climatedim)})
  tb5=reactive({get(input$climatetype4)})
  
  tb6=reactive({get(input$climatetype5)})
  tb7=reactive({get(input$climatetype6)})
  
  fil=colorRampPalette(c("red","yellow","green"))
  output$tableoutput=renderTable({
    if(input$climatedim=='rainfall'){
      subd=input$subdiv4
      yearn=input$yearno
      timeoy=input$time
      tb4() %>% filter(SUBDIVISION==subd & YEAR==yearn) %>% select(2,3:14)
    }else{
      yearn=input$yearno
      timeoy=input$time
      tb4() %>% filter(YEAR==yearn) %>% select(1,2:13)
    }
  })
  output$tableout2=renderTable({
    if(input$climatedim=='rainfall'){
      subd=input$subdiv4
      yearn=input$yearno
      timeoy=input$time
      tb4() %>% filter(SUBDIVISION==subd & YEAR==yearn) %>% select(2,16:19)
    }else{
      yearn=input$yearno
      timeoy=input$time
      tb4() %>% filter(YEAR==yearn) %>% select(1,15:18)
    }
  })
  output$tableout3=renderTable({
    if(input$climatedim=='rainfall'){
      subd=input$subdiv4
      yearn=input$yearno
      timeoy=input$time
      tb4() %>% filter(SUBDIVISION==subd & YEAR==yearn) %>% select(2,15)
    }else{
      yearn=input$yearno
      timeoy=input$time
      tb4() %>% filter(YEAR==yearn) %>% select(1,14)
    }
  })
  output$barmonth=renderPlot({
    if(input$climatetype=='rainfall'){
      monthly=input$month
      subd=input$subdiv
      lr=tb() %>% filter(SUBDIVISION==subd)
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,'YEAR'],y=lr[,monthly]))+geom_bar(stat='identity',fill=fil(nrow(lr)))+xlab("Years(1901-2015)")
    }else{
      monthly=input$month
      lr=tb()
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,'YEAR'],y=lr[,monthly]))+geom_bar(stat='identity',fill=fil(117))+xlab("Years(1901-2017)")
    }
  })
  output$barseason=renderPlot({
    
    if(input$climatetype=='rainfall'){
      season=input$seasonal
      subd2=input$subdiv
      gh=tb() %>% filter(SUBDIVISION==subd2)
      ggplot(gh,aes(x=gh[,'YEAR'],y=gh[,season]))+geom_bar(stat = 'identity',fill=fil(nrow(gh)))+xlab("Years(1901-2015)")
    }else{
      season=input$seasonal
      gh=tb()
      ggplot(gh,aes(x=gh[,'YEAR'],y=gh[,season]))+geom_bar(stat = 'identity',fill=fil(117))+xlab("Years(1901-2017)")
    }
  })
  output$barannual=renderPlot({
    
    if(input$climatetype=='rainfall'){
      yearly=input$annual
      subd3=input$subdiv
      lh=tb() %>% filter(SUBDIVISION==subd3)
      ggplot(lh,aes(x=lh[,'YEAR'],y=lh[,yearly]))+geom_bar(stat = 'identity',fill=fil(nrow(lh)))+xlab("Years(1901-2015)")
    }else{
      yearly=input$annual
      lh=tb()
      ggplot(lh,aes(x=lh[,'YEAR'],y=lh[,yearly]))+geom_bar(stat = 'identity',fill=fil(117))+xlab("Years(1901-2017)")
    }
  })
  output$scattermonth=renderPlot({
    if(input$climatetype2=='rainfall'){
      monthly=input$month2
      subd=input$subdiv2
      lr=tb2() %>% filter(SUBDIVISION==subd)
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,'YEAR'],y=lr[,monthly]))+geom_point(color="blue")+xlab("Years(1901-2015)")+geom_smooth(se=F)
    }else{
      monthly=input$month2
      lr=tb2()
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,'YEAR'],y=lr[,monthly]))+geom_point(color="blue")+xlab("Years(1901-2017)")+geom_smooth(se=F)
    }
  })
  output$scatterseason=renderPlot({
    if(input$climatetype2=='rainfall'){
      season=input$seasonal2
      subd=input$subdiv2
      lr=tb2() %>% filter(SUBDIVISION==subd)
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,'YEAR'],y=lr[,season]))+geom_point(color="blue")+xlab("Years(1901-2015)")+geom_smooth(se=F)
    }else{
      season=input$seasonal2
      lr=tb2()
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,'YEAR'],y=lr[,season]))+geom_point(color="blue")+xlab("Years(1901-2017)")+geom_smooth(se=F)
    }
  })
  output$scatterannual=renderPlot({
    if(input$climatetype2=='rainfall'){
      ann=input$annual2
      subd=input$subdiv2
      lr=tb2() %>% filter(SUBDIVISION==subd)
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,'YEAR'],y=lr[,ann]))+geom_point(color="blue")+xlab("Years(1901-2015)")+geom_smooth(se=F)
    }else{
      ann=input$annual2
      lr=tb2()
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,'YEAR'],y=lr[,ann]))+geom_point(color="blue")+xlab("Years(1901-2017)")+geom_smooth(se=F)
    }
  })
  output$linemonth=renderPlot({
    if(input$climatetype3=='rainfall'){
      monthly=input$month3
      subd=input$subdiv3
      lr=tb3() %>% filter(SUBDIVISION==subd)
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,'YEAR'],y=lr[,monthly]))+geom_line(color="blue")+xlab("Years(1901-2015)")+geom_smooth(se=F)
    }else{
      monthly=input$month3
      lr=tb3()
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,'YEAR'],y=lr[,monthly]))+geom_line(color="blue")+xlab("Years(1901-2017)")+geom_smooth(se=F)
    }
  })
  output$lineseason=renderPlot({
    if(input$climatetype3=='rainfall'){
      season=input$seasonal3
      subd=input$subdiv3
      lr=tb3() %>% filter(SUBDIVISION==subd)
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,'YEAR'],y=lr[,season]))+geom_line(color="blue")+xlab("Years(1901-2015)")+geom_smooth(se=F)
    }else{
      season=input$seasonal3
      lr=tb3()
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,'YEAR'],y=lr[,season]))+geom_line(color="blue")+xlab("Years(1901-2017)")+geom_smooth(se=F)
    }
  })
  output$lineannual=renderPlot({
    if(input$climatetype3=='rainfall'){
      ann=input$annual3
      subd=input$subdiv3
      lr=tb3() %>% filter(SUBDIVISION==subd)
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,'YEAR'],y=lr[,ann]))+geom_line(color="blue")+xlab("Years(1901-2015)")+geom_smooth(se=F)
    }else{
      ann=input$annual3
      lr=tb3()
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,'YEAR'],y=lr[,ann]))+geom_line(color="blue")+xlab("Years(1901-2017)")+geom_smooth(se=F)
    }
  })
  
  
  output$densitymonth=renderPlot({
    if(input$climatetype4=='rainfall'){
      subd=input$subdiv44
      monthly=input$month4
      lr=tb5() %>% filter(SUBDIVISION==subd)
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,monthly]))+geom_density(stat = 'density',position = 'identity',na.rm = FALSE,col="green",fill="blue")
    }else{
      monthly=input$month4
      lr=tb5()
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,monthly]))+geom_density(stat = 'density',position = 'identity',na.rm = FALSE,col="green",fill="blue")
    }
  })
  
  output$densityannual=renderPlot({
    
    
    if(input$climatetype4=='rainfall'){
      ann=input$annual4
      subd=input$subdiv44
      lr=tb5() %>% filter(SUBDIVISION==subd)
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,ann]))+geom_density(stat = 'density',position = 'identity',na.rm = FALSE,col="green",fill="blue")
    }else{
      ann=input$annual4
      lr=tb5()
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,ann]))+geom_density(stat = 'density',position = 'identity',na.rm = FALSE,col="green",fill="blue")
    }
  })
  
  
  output$densityseason=renderPlot({
    
    if(input$climatetype4=='rainfall'){
      season=input$seasonal4
      subd=input$subdiv44
      lr=tb5() %>% filter(SUBDIVISION==subd)
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,season]),col="green")+geom_density(stat = 'density',position = 'identity',na.rm = FALSE,col="green",fill="blue")
    }else{
      season=input$seasonal4
      lr=tb5()
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,season]),col="green")+geom_density(stat = 'density',position = 'identity',na.rm = FALSE,col="green",fill="blue")
    }
  })
  
  
  
  
  output$histomonth=renderPlot({
    if(input$climatetype5=='rainfall'){
      subd=input$subdiv5
      monthly=input$month5
      lr=tb6() %>% filter(SUBDIVISION==subd)
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,monthly]))+geom_histogram(col="cadetblue",fill="red")
    }else{
      monthly=input$month5
      lr=tb6()
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,monthly]))+geom_histogram(col="cadetblue",fill="red")
    }
  })
  
  output$histoannual=renderPlot({
    
    
    if(input$climatetype5=='rainfall'){
      ann=input$annual5
      subd=input$subdiv5
      lr=tb6() %>% filter(SUBDIVISION==subd)
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,ann]))+geom_histogram(col="cadetblue",fill="red")
    }else{
      ann=input$annual5
      lr=tb6()
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(x=lr[,ann]))+geom_histogram(col="cadetblue",fill="red")
    }
  })
  
  
  output$histoseason=renderPlot({
    
    if(input$climatetype5=='rainfall'){
      season=input$seasonal5
      subd=input$subdiv5
      lr=tb6() %>% filter(SUBDIVISION==subd)
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(y=lr[,season]),col="green")+geom_histogram(col="cadetblue",fill="red")
    }else{
      season=input$seasonal5
      lr=tb6()
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(y=lr[,season]),col="green")+geom_histogram(col="cadetblue",fill="red")
    }
  })
  
  
output$boxmonth=renderPlot({
    if(input$climatetype6=='rainfall'){
      subd=input$subdiv6
      monthly=input$month6
      lr=tb7() %>% filter(SUBDIVISION==subd)
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(y=lr[,monthly]))+geom_boxplot(col="cadetblue",fill="red")
    }else{
      monthly=input$month6
      lr=tb7()
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(y=lr[,monthly]))+geom_boxplot(col="cadetblue",fill="red")
    }
  })
  
  output$boxannual=renderPlot({
    
    
    if(input$climatetype6=='rainfall'){
      ann=input$annual6
      subd=input$subdiv6
      lr=tb7() %>% filter(SUBDIVISION==subd)
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(y=lr[,ann]))+geom_boxplot(col="cadetblue",fill="red")
    }else{
      ann=input$annual6
      lr=tb7()
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(y=lr[,ann]))+geom_boxplot(col="cadetblue",fill="red")
    }
  })
  
  
  output$boxseason=renderPlot({
    
    if(input$climatetype6=='rainfall'){
      season=input$seasonal6
      subd=input$subdiv6
      lr=tb7() %>% filter(SUBDIVISION==subd)
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(y=lr[,season]),col="green")+geom_boxplot(col="cadetblue",fill="red")
    }else{
      season=input$seasonal6
      lr=tb7()
      fil=colorRampPalette(c("red","yellow","green"))
      ggplot(lr,aes(y=lr[,season]),col="green")+geom_boxplot(col="cadetblue",fill="red")
    }
  })

  
  
  
  
  output$summary1=renderPrint(
    {
      if(input$SI1>input$SI2){
        (min_temp %>% filter(YEAR<=input$SI1 & YEAR>=input$SI2) %>% select(input$ch1))
      }else{
        (min_temp %>% filter(YEAR>=input$SI1 & YEAR<=input$SI2) %>% select(input$ch1))
      }}
  )
  output$summary2=renderPrint(
    {
      if(input$SI1>input$SI2){
        (mean_temp %>% filter(YEAR<=input$SI1 & YEAR>=input$SI2) %>% select(input$ch1))
      }else{
        (mean_temp %>% filter(YEAR>=input$SI1 & YEAR<=input$SI2) %>% select(input$ch1))
      }}
  )
  output$summary3=renderPrint(
    {
      if(input$SI1>input$SI2){
        (max_temp %>% filter(YEAR<=input$SI1 & YEAR>=input$SI2) %>% select(input$ch1))
      }else{
        (max_temp %>% filter(YEAR>=input$SI1 & YEAR<=input$SI2) %>% select(input$ch1))
      }}
  )
  
  
  
  
  output$summary4=renderPrint(
    {
      if(input$SI1>input$SI2){
        (min_temp %>% filter(YEAR<=input$SI1 & YEAR>=input$SI2) %>% select(as.integer(input$ch3)))
      }else{
        (min_temp %>% filter(YEAR>=input$SI1 & YEAR<=input$SI2) %>% select(as.integer(input$ch3)))
      }}
  )
  output$summary5=renderPrint(
    {
      if(input$SI1>input$SI2){
        (mean_temp %>% filter(YEAR<=input$SI1 & YEAR>=input$SI2) %>% select(as.integer(input$ch3)))
      }else{
        (mean_temp %>% filter(YEAR>=input$SI1 & YEAR<=input$SI2) %>% select(as.integer(input$ch3)))
      }}
  )
  output$summary6=renderPrint(
    {
      if(input$SI1>input$SI2){
        (max_temp %>% filter(YEAR<=input$SI1 & YEAR>=input$SI2) %>% select(as.integer(input$ch3)))
      }else{
        (max_temp %>% filter(YEAR>=input$SI1 & YEAR<=input$SI2) %>% select(as.integer(input$ch3)))
      }}
  )
  
  
  output$result=renderTable({
    table1=rainfall %>% filter(YEAR>=input$selyear[1] & YEAR<=input$selyear[2]) %>% select(YEAR,SUBDIVISION,input$selmonth[1]:input$selmonth[2])
    SUM=rowSums(table1[input$selmonth[1]:input$selmonth[2]])
    table2=table1 %>% mutate(SUM=SUM)
    table2=table2 %>% group_by(SUBDIVISION) %>% summarise(Sum=sum(SUM))
    table2=table2 %>% filter(Sum==max(Sum))
    
    
    
    table1 %>% filter(SUBDIVISION==table2$SUBDIVISION)
  })
  
  
  
}

shinyApp(ui,server)

