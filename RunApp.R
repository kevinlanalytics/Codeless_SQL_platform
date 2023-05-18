# Use this RunApp script to run the shiny app 

library(DBI)#need to call SQL database
library(dbplyr)#to translate R code to SQL - we might not use it 
library(dplyr)# to do %>% 
library(shiny)
library(odbc)


con <- dbConnect( odbc(),
                  Uid = rstudioapi::askForPassword("User"),
                  Pwd = rstudioapi::askForPassword("Password!"),
                  Driver = "ODBC Driver 17 for SQL Server",
                  Server = "",
                  Database = "v",
                  Port = ,
                  Authentication="ActiveDirectoryPassword"
)


all_df <-data.frame(con %>% tbl(sql('SELECT * FROM INFORMATION_SCHEMA.COLUMNS')))
all_df <- all_df %>% select("TABLE_CATALOG", "TABLE_SCHEMA", "TABLE_NAME", "COLUMN_NAME", "DATA_TYPE")
public_tables <- c("CbpAirArrivals", "TsaSecureFlightAirArrivals", "CbpLandArrivals")
all_df <- all_df[all_df$TABLE_NAME %in% public_tables,]
all_tables <- unique(all_df['TABLE_NAME']) # the UI selection of all the table available for selection
source("server.R")
source("ui.R")

shiny::runApp()

