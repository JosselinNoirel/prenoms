#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library('shiny')

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Fréquence des prénoms au cours du temps (1900-2021)"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            textInput('list', 'Selection of names',
                      value='male: CAMILLE, female: CAMILLE, HÉLOÏSE')
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("plot"),
            tableOutput('stats'),
            p('(1) les fréquences sont calculées parmi les enfants de même sexe.'),
            p('(2) les fréquences et les rangs sont calculés parmi les enfants de même sexe.'),
            p('(3) les fréquences sont données en pour mille.'),
        )
    )
))
