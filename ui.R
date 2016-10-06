library(shiny)

source("./helper.R")

wine <- rbind(redW, whiteW)
		
shinyUI(fluidPage(
	tabsetPanel(
		tabPanel("Quality Prediction",
			headerPanel('Portuguese "Vinho Verde" wine quality prediction'),
				fluidRow(
					column(12, offset=0.1,
						div( 
							br(),
							p('Two different datasets, based on samples, are used to predict quality
							 of red and white variants of the Portuguese "Vinho Verde" wine.'),
							p('The quality is based on sensory data made by wine expert and it is graded between 0
							 "very bad" and 10 "very excellent".'),
							h3("Instructions:"),
							tags$ol(
								tags$li("Chose the type of wine"),
								tags$li("Select the variable to be plotted"),
								tags$li("Change the values of variables acting on their sliders")
                            )
						)
					)
				),
				sidebarLayout(
					sidebarPanel(
						fluidRow(
							column(12, offset=0.1, wellPanel(
								radioButtons("wineType", label = h4("Vinho Verde Wine Type:"),
								   list("Red" = "red", "White" = "white"))
								)
							)
						),
						fluidRow(
							column(12, offset=0.1, wellPanel(
								selectInput('varplot', label = h4("Select variable to plot"), names(wine[,1:11]))
								)
							)
						),
						fluidRow(						
							column(12, offset=0.1, wellPanel(
								h4("Change variables values"),
								lapply(1:11, function(i){
									ifelse(i != 9 & i != 11 & i != 12, lab <- eval(parse(text = sliderLabel[i])), lab <- sliderLabel[i])
									sliderInput(inputId=names(wine)[i], label = div(span(lab, style="font-size: 13px")),
										min = round(min(wine[,i]),2),
										max = round(max(wine[,i]),2),
										value = round(mean(wine[,i]),2),
										step= (max(wine[,i]) - min(wine[,i]))/100,
										width='100%')
										}
									)
								)
							)
						)
					),
					mainPanel(
						column(6, offset=0.1,
							h3("Predicted Quality:"),
							uiOutput("prediction"),
							tableOutput("table")
						),
						column(8, offset=0.1,
							plotOutput("plotVar")
						)
					)
				)	
			),
            tabPanel("Model",
				fluidRow(
					column(11, offset=0.1,
						div(
							h4("Quality distribution of the selected wine type dataset:"),
								p('The plot represents the distribution of variable quality in the dataset for the selected wine type'),
								br()
							)
					)
				),
				fluidRow(
					column(11, offset=0.1,
						   plotOutput("plotDSWineQual")
					)
				),
                fluidRow(
                    column(11, offset=0.1,
                        div(
							h4("Model accuracy:"),
							p('The prediction is based on Random Forest model.'),
							htmlOutput("wineAccuracyModel")
                        )
                    )
                )
            ),
			tabPanel("Dataset",
				fluidRow(
					column(11, offset=0.1,
                        div(
							h4("Dataset:"),
							p('The two dataset are available on the,', a(href="https://archive.ics.uci.edu/ml/datasets/wine+Quality", "UCI Machine Learning Repository"), ' site, they are related to red and white variants of
								the Portuguese Vinho Verde wine.'),
							p('Vinho Verde is a Portuguese wine from the Minho region in the far
								north of the country. The name literally means "Green Wine" (red or white), referring to its youthful
								freshness that leads to a very slight green color on the edges of the wine.'),
							br(),
							h4("Source:"),
							p(a(href="http://www3.dsi.uminho.pt/pcortez", "Paulo Cortez"), "University of Minho, Guimarães, Portugal,
							A. Cerdeira, F. Almeida, T. Matos and J. Reis, Viticulture Commission of the Vinho Verde Region(CVRVV), Porto, Portugal
							@2009"),
							br(),
							h4("Citation:"),
							tags$i("P. Cortez, A. Cerdeira, F. Almeida, T. Matos and J. Reis.
								 Modeling wine preferences by data mining from physicochemical properties.
								 In Decision Support Systems, Elsevier, 47(4):547-553. ISSN: 0167-9236.")                                 
                        )
                    )
                )
            )
		)
	)
)