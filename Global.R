#Global script would run the same time when the app launches - it loads up the background 

# Loading the required packages 
# library(DBI)#need to call SQL database
library(tidyverse)
library(dplyr)
library(tidyr)
library(readxl)#to read excel files
library(readr)#to read .csv and SQL code files 
library(stringr)#to parse the strings 
library(shinydashboard)# customizable box for dash organization 
library(DT)# customizable data table function library
library(shinyjs)
library(htmltools)# for advanced datatable function 
library(ggplot2)
library(fmtr)# dataTable formating library
library(shinyBS)
library(lubridate)



# importing all tables and its column names 
# con = NULL


S_columns2 = "None"



# importing/ sourcing the R script 
# DataName = source('tableNameList.R')[1]

# Create list of the SQL file for user to select on the data they want 
# list_SQL = data.frame(gsub(".sql","", list.files(path="SQL")))

# SQL Modularizer  
##SELECT and FROM Script
select_str = "SELECT "
from_str = " FROM [EDAV].[ncezidview]."


## String for date
date_str1 = " WHERE "
date_str2 = ">="
date_str3 = " 00:00:00.000" 
date_str4 = " and "
date_str5 = "<="
date_str6 = " 23:59:59.000" 

## group by for sample pull - potentially customize by users 
### (needed this line to pull sample_pull.sql)
groupby_Str = " GROUP BY"

##
#SQuery_final = "no data selected"

#select distinct string
select_dist<-"SELECT DISTINCT "

# Define user data for blank
User_data <- NULL
#User_col <- NULL
filtered_data <- NULL
option_list = NULL
SQL_proN <-""
SQL_pro <-""


#Testing strings for export to txt
first_text <- "#Export to R/RMD ---> Gather standard code into R 
#Required Packages ----
library(DBI)#need to call SQL database
library(tidyverse)
library(dplyr)
library(tidyr)
library(readxl)#to read excel files
library(readr)#to read .csv and SQL code files 
library(stringr)#to parse the strings 
library(shinydashboard)# customizable box for dash organization 
library(DT)# customizable data table function library
library(shinyjs)
library(htmltools)# for advanced datatable function 
library(ggplot2)
#Global connection ----
server <- 'Edav-synapse.database.windows.net'
database = 'EDAV'
con <- DBI::dbConnect(odbc::odbc(), 
                      UID = rstudioapi::askForPassword('account email'),
                      Driver='ODBC Driver 17 for SQL Server',
                      Server = server, Database = database,
                      Authentication = 'ActiveDirectoryInteractive')
SQL_PULL<- data.frame(con %>% tbl(sql(\""
second_text <- "\")))"
