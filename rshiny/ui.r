library(magrittr)
library(shiny)
# Define the UI
ui <- bootstrapPage(
  h3(textOutput("currentTime")),
  h3(textOutput("currentVersion")),
  h3(textOutput("currentw")),
  h3(textOutput("currentD1temp")),
  h3(textOutput("currentD2temp")),
  h3(textOutput("currentpf")),
  h3(textOutput("currentmeanpf")),
  h3(textOutput("currentodaykwh")),
  h3(textOutput("currentdays")),
  h3(textOutput("currentkwh")),
  h3(textOutput("averagekwh")),
  
  #numericInput('n', 'Number of obs', n),

  plotOutput('plotv'),
  plotOutput('plota'),
  plotOutput('plottav'),
  plotOutput('plotav'),
  plotOutput('plotw'),
  plotOutput('plotD1temp'),
  plotOutput('plotD2temp'),
  plotOutput('plotD1D2temp'),
  plotOutput('plotkwh'),
  plotOutput('plotwav'),
  plotOutput('plotkwht'),
  plotOutput('plotkwhday'),
  plotOutput('plotghosths')
  
)
