library(shiny)

shinyServer(function(input, output) {
      # Get wine type selected
      wineT <- reactive({
            wineType <- input$wineType
            return(as.character(wineType))
      })

      # Get values variables selected
      varValue <- reactive({
            ifelse(wineT() == "red", wineSelect <- redW, wineSelect <- whiteW)

            selection <- as.data.frame(t(sapply(names(wineSelect)[1:11], function(i) input[[i]])))
            selection$type.wine.selected <- as.factor(input$wineType)
            selection <- selection[,c(12,1:11)]
            row.names(selection) <- c("Selected variables values")
            return(selection)

      })

      # Summarize values of the input variables selected
      output$table <- renderTable({t(varValue())}, align='cc')

      # Prepare data to plot given user selection of wine type and variable to plot
      output$plotVar <- renderPlot({
            ifelse(wineT() == "red", wineSelect <- redW, wineSelect <- whiteW)

            x <- seq(min(wineSelect[,input$varplot]), max(wineSelect[,input$varplot]), length.out = 150);
            varVal <- varValue()[rep(1,150),]
            varVal[,input$varplot] <- x

            ifelse(wineT() == "red", modelWineType <- modelRedW, modelWineType <- modelWhiteW)
            y <- predict(modelWineType, newdata = varVal)
            plot(y ~ x, xlab = input$varplot, ylab = "Quality",
                 type = "l", cex.main = 1.5, cex.axis = 1.05, cex.lab = 1.4, lwd = 1.3,
                 col = "deepskyblue4", col.lab = "deepskyblue4", col.main = "deepskyblue4",
                 col.axis = "deepskyblue4",
                 main = paste("Quality prediction for", input$varplot, "\n",
                            "variable values selected"))
      })

      # Generate quality predicted value
      output$prediction <- renderUI({
            ifelse(wineT() == "red", modelWineType <- modelRedW, modelWineType <- modelWhiteW)
            h3(round(predict(modelWineType, newdata = varValue()), 1))
      })

      # Evaluate quality distribution in the dataset
      output$plotDSWineQual <- renderPlot({

            if (wineT() == "red") {
                  winePlot <- table(redW$quality)
                  wineMain <- "Dataset Red Wine Rank by Quality"
            } else {
                  winePlot <- table(whiteW$quality)
                  wineMain <- "Dataset White Wine Rank by Quality"
            }

      barplot(winePlot, main = wineMain,
              xlab = "Quality", ylab = "Frequency", col = "slategray1",
              cex.main = 1.3, cex.axis = 1.1, cex.lab = 1);

      })

      # Get accuracy from wine type model
            output$wineAccuracyModel <- renderUI({
                  ifelse(wineT() == "red", accuracyRFModel <- redAccuracy, accuracyRFModel <- whiteAccuracy)
                  str1 <- paste("The selected wine type is", wineT())
                  str2 <- paste("and the accuracy relate model is", accuracyRFModel, "%.")
                  HTML(paste(str1, str2))

            })

})
