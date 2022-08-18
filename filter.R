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
dataset=c("Min Temperature for 117 years"="min_temp",
          "Max Temperature for 117 years"="max_temp",
          "Average Temperature for 117 years"="mean_temp",
          "Rainfall for 115 years"="rainfall")
ui=dashboardPage(dashboardHeader(title = "Filtered"),
                 dashboardSidebar(
                 sidebarMenu(
                   menuItem(tabName = "filter",text="MORE...")
                 )
                 ),
                 dashboardBody(tabItems(
                   tabItem(text="Want to ask Queries ? ",tabName = "filter",
                           tabsetPanel(tabPanel(
                             fluidRow(box(sliderInput(inputId = "selyear",label = "Select the range of years",
                                                      min=rainfall[1,2],max = rainfall[nrow(rainfall),2],value = c(1967,1988))),
                                      box(sliderInput(inputId = "selmonth",label = "select the range of months",
                                                      min = 3,max=14,value = c(3,4))),
                                      box(tableOutput("result"))
                                      )
                           )
                          
#                           tabPanel(fluidRow(box(sliderInput(inputId = "selyear2",label = "Select the Range of Years",
 #                                                            min=rainfall[1,2],max = rainfall[nrow(rainfall),2],value=c(min,max)),
  #                                               ),
   #                                          box(sliderInput(inputId = "selmonth2",label = "Select the Range of months",
    #                                                         min = 3,max = 14,value = c(min,max))),
     #                                        box(sliderInput(inputId = "top10entries",label = "Select the no of entries you want to display",
      #                                                       min = 1,max = 36,value = c(min,max))),
       #                                      box(selectInput(inputId = "type",label = "Select Maximum or Minimum",choices=c("Max","Min"))),
        #                                     box(tableOutput("result2"))))
                           ) )))
                 )
server=function(input,output){
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
