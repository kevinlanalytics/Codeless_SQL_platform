source('Global.R')# import connection prompt code

server <- function( input, output, session ) {
  updateSelectInput(session, "variable1", "Select a Data table:", choices = all_tables, selected = NULL) 
  
  
  observeEvent(input$variable1,{# import the SQL query base structure with reactive session
    table_Select <- all_df %>% filter(TABLE_NAME==input$variable1) # filter the data frame based on the table user selected
    SQuery_col2 <<- table_Select['COLUMN_NAME'] # Based what user selected this is the full column lists
    updateSelectizeInput(session, "col_select", "Select Data column(s):", choices = SQuery_col2)
    from_str2 <<- paste(from_str,"[",input$variable1,"]", sep="")
  })
  
  
  observeEvent(input$col_select,{
    S_inputCol <<- list(input$col_select)[[1]]
    Date_index <<- which(grepl("date", SQuery_col2[[1]], useBytes=TRUE, ignore.case=TRUE))
    Date_index2 <<- which(grepl("date", S_inputCol, useBytes=TRUE, ignore.case=TRUE))
    option_list <<- S_inputCol[-Date_index] #showing all non date elements: using Date_index to take out all "date" elements
    # option_list2 <<- SQuery_col2[-Date_index]
    date_list <- S_inputCol[Date_index2]
    
    output$filters <- renderUI({
      selectInput(inputId =  "data_Pro1",
                  label = "Choose a date-column for range selection",
                  choices = date_list)
    })
    updateSelectizeInput(session, "data_Pro2", "Choose a column for processing", choices = c(option_list,"None"), selected = 'None')
    updateSelectizeInput(session, "data_Pro3", "Choose a column for creating a new label", choices = c(option_list,"None"), selected = 'None')
    S_columns <<- input$col_select
    S_columns2 <<- paste(S_columns, collapse = ",")
    S_columns3 <<- S_columns2
  })
  
  
  
  
  reactive_option <- reactive({
    if(input$data_Pro2 != 'None'){
      return(c("Sum"="SUM","Average"="AVG","Minimum"="MIN", "Maximum"="MAX", "Variance"="VAR"))}
    else{
      return('None')
    }
  })
  observeEvent(input$data_Pro2,{
    freezeReactiveValue(input, "filters3")
    updateSelectInput(session = session, inputId = "filters3", choices = reactive_option())
  })
  
  observeEvent(input$filters3,{
    SQL_proN <- gsub("\\[|\\]", "",input$data_Pro2)
    SQL_pro <- paste(input$filters3,"(",SQL_proN,")")
    S_columns3 <<- gsub(" ","",paste(input$filters3,"_",SQL_proN,"=",SQL_pro,",",S_columns2))
    
  })
  
  
  observeEvent(input$data_Pro1,{  
    output$filters1 <- renderUI({
      dateRangeInput(inputId = "date_select",
                     label = paste("Choose date range from", " ", input$data_Pro1))
    })
  })
  
  
  
  
  observeEvent(
    input$SubmitButton,{
      groupby_Str2 <- paste(groupby_Str,S_columns2)# Creating phrase for groupBy, based off from order of column selection
      SQL_date = input$date_select
      date_col <- gsub("\\[|\\]", "",input$data_Pro1)
      date_SQL = paste(date_str1,date_col,date_str2,"'",SQL_date[1],date_str3,"'",date_str4,date_col,date_str5,"'",SQL_date[2],date_str6,"'",sep="")
      if(input$data_Pro2 == 'None'){
        S_columns3 <<- S_columns2
        SQuery_final <<- paste(select_str,S_columns3, from_str2,date_SQL,groupby_Str2,sep="")# combine all string pieces together
      }else{
        SQuery_final <<- paste(select_str,S_columns3, from_str2,date_SQL,groupby_Str2,sep="")# combine all string pieces together
      }
      
      
      Data_pull <- data.frame(con %>% tbl(sql(SQuery_final))) # the finalized SQL code for pulling the data
      User_data <<- Data_pull
      DateCol_index <- which(grepl("date", names(User_data), useBytes=TRUE, ignore.case=TRUE))# identify column name contain "date" 
      User_data[DateCol_index] <- format(User_data[DateCol_index], "%Y-%m-%d") # and change column to date format
      output$text1 <- renderText({paste("The SQL code:")})
      output$text2 <- renderText({SQuery_final})
      output$table1 = renderDataTable({
        datatable(User_data, filter="top")#
      })
      output$table2 = renderDataTable({
        datatable(User_data, filter="top")
      })
      User_col <<- colnames(User_data)
      updateSelectInput(session = getDefaultReactiveDomain(), "X_variable", "X Axis Variable", choices = User_col, selected = 'None')
      updateSelectInput(session = getDefaultReactiveDomain(), "Y_variable", "Y Axis Variable", choices = User_col, selected = 'None')
    })
  
  
  
  
  observeEvent(input$SubmitButton2, {
    if(input$X_variable!='None' & input$Y_variable!='None'){
      filtered_data <<- User_data[input$table2_rows_all,]
      y_var <<- toString(input$Y_variable)
      x_var <<- toString(input$X_variable)
      filtered_data <<- filtered_data %>% select(x_var, y_var)
      p_type <<-input$plotType
      plotplot <<- ggplot(
        data=filtered_data, 
        mapping=aes(x=filtered_data[[1]],y=filtered_data[[2]])) + match.fun(input$plotType)() + labs(x = x_var, y=y_var)
      output$plot=renderPlot(plotplot)
    }
    print('Hello World')
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("traveldatascript", Sys.Date(), ".R",sep = "")
    },
    content = function(file) {
      writeLines(paste(first_text,SQuery_final,second_text, collapse = ", "), file)
    }
  )
  
  # reactive stop for DB connection  
  #onStop(function() odbc::dbDisconnect(con))
  output$summary <- renderPrint({summary(User_data)})
  # output$class <- renderPrint({class(User_data)})
  output$row <- renderText({paste("Number of Column(s):",length(User_data[0,]))})
  output$col <- renderText({paste("Number of Row(s):", nrow(User_data) )})
  # output$table <- DT::renderDataTable({DT::datatable(cars)})# no UI handle for the table 
}
