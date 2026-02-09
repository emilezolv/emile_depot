library(shiny)

fluidPage(
  titlePanel("Calculateur d'IMC"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("poids", "Poids (kg):", value = 70, min = 1, max = 300),
      numericInput("taille", "Taille (cm):", value = 170, min = 50, max = 250),
      actionButton("calculer", "Calculer")
    ),
    
    mainPanel(
      h3("Votre IMC:"),
      textOutput("imc"),
      textOutput("categorie"),
      plotOutput("graphique_imc")
    )
  )
)
