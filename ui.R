#
# by Xiangzhen Kong @ MPI, Nijmegen
#
library(shiny)
library(shinyalert)
library(markdown)
#library(shinycssloaders)

dat_dir = './data/French2015'
gene_list = read.csv(file.path(dat_dir, 'obs.gene_list.csv'),header = FALSE, col.names = c('gene'))
gene_list = gene_list['gene']
refresh_tag = FALSE

ui <- navbarPage("obsBrain: Observatory of Brain",
                 tabPanel("Gene in Brain",
                          sidebarLayout(
                            sidebarPanel(
                              useShinyalert(),
                              selectInput("gene_src",
                                          "Select Data Source:",
                                          choices = c('French2015_both hemi', 'Arnatkeviciute2018_left hemi')),
                              selectInput("gene_gene",
                                          "Input Gene of Interest:",
                                          choices = gene_list, 
                                          selected='S100B'),
                              selectInput("gene_hemi",
                                          "Select Hemisphere:",
                                          choices = c('both','left','right'),
                                          selected = 'left'),
                              selectInput("gene_view",
                                          "Select View:",
                                          choices = c('both','lateral','medial')),
                              conditionalPanel(condition = "input.gene_hemi=='both'",
                                               checkboxInput("gene_position", 
                                                             "Subplots stacked?",
                                                             value = TRUE)),
                              checkboxInput("gene_grid_axis",
                                            "With grid and axis information?",
                                            value = FALSE),
                              checkboxInput("gene_legend",
                                            "Show legend?",
                                            value = TRUE),
                              checkboxInput("gene_rank",
                                            "Show data rank?",
                                            value = TRUE),
                              sliderInput("gene_line_size",
                                          "Contour line size:",
                                          min = 0,
                                          max = 1,
                                          step = 0.05,
                                          value = 0.25),
                              checkboxInput("gene_line_color",
                                            "Contour line in black (or white)?",
                                            value = TRUE),
                              textInput("gene_plot_area",
                                        "Input Area(s) of Interest:",NULL)
                              
                            ),
                            mainPanel(
                              if(refresh_tag){
                                withSpinner(plotOutput("obsBrainPlot1"), type=6, color = '#ffd700')
                              }else{
                                plotOutput("obsBrainPlot1")
                              }
                              )
                            )
                          ),
                 tabPanel("About",
                          fluidRow(
                            column(1),
                            column(8,
                                   includeMarkdown("README.md")
                                   )
                          )
                 )
                 )

