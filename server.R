#
# by Xiangzhen Kong @ MPI, Nijmegen
#
library(ggseg)
library(shiny)
library(shinyalert)
library(feather)

gene_area_dat1_all = NULL
gene_area_dat2_all = NULL

readData <- function(session) {
  progress <- Progress$new(session)
  progress$set(value = 0.3, message = 'Loading...')
  gene_area_file1 = file.path('./data/French2015', 'obs.DAT/obsDat.feather') 
  gene_area_dat1_all <<- read_feather(gene_area_file1)
  progress$set(value = 0.75, message = 'Loading...')
  gene_area_file2 = file.path('./data/Arnatkeviciute2018', 'obs.DAT/obsDat.feather')
  gene_area_dat2_all <<- read_feather(gene_area_file2)  
  progress$set(value = 1, message = 'Loading...')
  progress$close()
}
# Data Loading without loading progress
#gene_area_file1 = file.path('./data/French2015', 'obs.DAT/obsDat.feather') 
#gene_area_dat1_all = read_feather(gene_area_file1)
#gene_area_file2 = file.path('./data/Arnatkeviciute2018', 'obs.DAT/obsDat.feather')
#gene_area_dat2_all = read_feather(gene_area_file2)

server <- function(input, output, session) {
  #print(1)
  #dataInput <- reactive({
  #  data_load(sess, gene_area_file)
  #})
  # For loading progress
  if(is.null(gene_area_dat2_all)){
    readData(session)
  }

  output$obsBrainPlot1 <- renderPlot({
    gene_atlas = 'dkt'

    if(input$gene_src=='French2015_both hemi'){
      dat_dir = './data/French2015'
      gene_area_dat_all = gene_area_dat1_all
    }else{
      dat_dir = './data/Arnatkeviciute2018'
      gene_area_dat_all = gene_area_dat2_all
    }

    area_list = read.csv(file.path(dat_dir,'obs.area_list.csv'),header = FALSE, col.names = c('area'))
    area_list = as.character(unlist(area_list['area']))
    hemi_list = read.csv(file.path(dat_dir, 'obs.hemi_list.csv'),header = FALSE, col.names = c('hemi'))
    hemi_list = as.character(unlist(hemi_list['hemi']))
    hemi_list = gsub('lh','left',hemi_list)
    hemi_list = gsub('rh','right',hemi_list)
    
    gene_list = read.csv(file.path(dat_dir,'obs.gene_list.csv'),header = FALSE, col.names = c('gene'))
    gene_list = as.character(unlist(gene_list['gene']))

    if(!is.element(input$gene_gene, gene_list)){
      shinyalert("Oops!", "This gene might not be included in the Data Source selected!", type = "warning")
      return()
    }
    gene_area_dat = as.double(unlist(gene_area_dat_all[input$gene_gene]))
    if(input$gene_rank){
      gene_area_dat = rank(gene_area_dat, ties.method = 'average')
      gene_legend = 'Rank'
      }else{
        gene_legend = 'Expression'
      }

    gene_data = data.frame(
      area = area_list,
      hemi = hemi_list,
      expression = gene_area_dat,
      stringsAsFactors = FALSE)

    if(input$gene_hemi == 'both'){
      hemi_input = NULL
    }else{
      hemi_input=input$gene_hemi
      gene_data['area'] = gene_data['area'][gene_data['hemi']==input$gene_hemi]
      gene_data['expression'] = gene_data['expression'][gene_data['hemi']==input$gene_hemi]
      gene_data['hemi'] = gene_data['hemi'][gene_data['hemi']==input$gene_hemi]
    }
    if(input$gene_view == 'both'){
      view_input = NULL
    }else{
      view_input=input$gene_view
    }
    if(input$gene_plot_area==''){
      plot_area_input = NULL
    }else{
      plot_area_input=gsub(",",";",input$gene_plot_area)
      plot_area_input=gsub("^ *| *$","",unlist(strsplit(plot_area_input,';')))
    }
    if(input$gene_position==TRUE){
      posi_input='stacked'
    }else{
      posi_input='dispersed'
    }
    if(input$gene_line_color==TRUE){
      gene_line_color = 'black'
    }else{
      gene_line_color = 'white'
    }
    
    if(input$gene_grid_axis){
      ggseg(data=gene_data,
            atlas=gene_atlas, 
            position = posi_input,
            view = view_input,
            hemisphere = hemi_input,
            colour = gene_line_color,
            size = input$gene_line_size,
            plot.areas = plot_area_input,
            show.legend = input$gene_legend,
            mapping=aes(fill=expression)) +
        scale_fill_gradient(low = "red", high = "yellow",name = gene_legend)
    }else{
      ggseg(data=gene_data,
            atlas=gene_atlas, 
            position = posi_input,
            view = view_input,
            hemisphere = hemi_input,
            colour = gene_line_color,
            size = input$gene_line_size,
            plot.areas = plot_area_input,
            show.legend = input$gene_legend,
            mapping=aes(fill=expression)) + 
        scale_fill_gradient(low = "red", high = "yellow",name = gene_legend) + 
        theme_void()
    }
    })
  
  # start obsBrainPlot3--------------------------------------------------------
  output$viewer_dataSelect <- renderUI({
    input_file = input$viewer_fileUpload
    if(is.null(input_file)){return()}
    viewer_data = read.csv(input_file$datapath)
    viewer_data_list = colnames(viewer_data)[-c(1,2)]
    
    list(hr(),
         selectInput("viewer_data",
                     "Select Data of Interest:",
                     choices = viewer_data_list))
  })
  output$obsBrainPlot3 <- renderPlot({
    if(is.null(input$viewer_fileUpload)){return()}
    
    viewer_atlas = 'dkt'

    viewer_data_all = read.csv(input$viewer_fileUpload$datapath)
    
    area_list = as.character(unlist(viewer_data_all['area']))
    hemi_list = as.character(unlist(viewer_data_all['hemi']))
    hemi_list = gsub('lh','left',hemi_list)
    hemi_list = gsub('rh','right',hemi_list)
    
    if(is.null(input$viewer_data)){
      input_viewer_data = colnames(viewer_data_all)[-c(1,2)][1]
    }else{
      input_viewer_data = input$viewer_data
    }
    viewer_area_dat = as.double(unlist(viewer_data_all[input_viewer_data]))
    if(input$viewer_rank){
      viewer_area_dat = rank(viewer_area_dat, ties.method = 'average')
      viewer_legend = 'Effect Rank'
    }else{
      viewer_legend = 'Effect'
    }
    
    viewer_data = data.frame(
      area = area_list,
      hemi = hemi_list,
      effect = viewer_area_dat,
      stringsAsFactors = FALSE)

    if(input$viewer_hemi == 'both'){
      hemi_input = NULL
    }else{
      hemi_input=input$viewer_hemi
      viewer_data['area'] = viewer_data['area'][viewer_data['hemi']==input$viewer_hemi]
      viewer_data['effect'] = viewer_data['effect'][viewer_data['hemi']==input$viewer_hemi]
      viewer_data['hemi'] = viewer_data['hemi'][viewer_data['hemi']==input$viewer_hemi]
    }
    if(input$viewer_view == 'both'){
      view_input = NULL
    }else{
      view_input=input$viewer_view
    }
    if(input$viewer_plot_area==''){
      plot_area_input = NULL
    }else{
      plot_area_input=gsub(",",";",input$viewer_plot_area)
      plot_area_input=gsub("^ *| *$","",unlist(strsplit(plot_area_input,';')))
    }
    if(input$viewer_position==TRUE){
      posi_input='stacked'
    }else{
      posi_input='dispersed'
    }
    if(input$viewer_line_color==TRUE){
      viewer_line_color = 'black'
    }else{
      viewer_line_color = 'white'
    }
    
    if(input$viewer_grid_axis){
      ggseg(data=viewer_data,
            atlas=viewer_atlas, 
            position = posi_input,
            view = view_input,
            hemisphere = hemi_input,
            colour = viewer_line_color,
            size = input$viewer_line_size,
            plot.areas = plot_area_input,
            show.legend = input$viewer_legend,
            mapping=aes(fill=effect)) +
        scale_fill_gradient(low = "red", high = "yellow",name = viewer_legend)
    }else{
      ggseg(data=viewer_data,
            atlas=viewer_atlas, 
            position = posi_input,
            view = view_input,
            hemisphere = hemi_input,
            colour = viewer_line_color,
            size = input$viewer_line_size,
            plot.areas = plot_area_input,
            show.legend = input$viewer_legend,
            mapping=aes(fill=effect)) + 
        scale_fill_gradient(low = "red", high = "yellow",name = viewer_legend) + 
        theme_void()
    }
  })
  output$viewer_tbl <- renderTable({
    if(is.null(input$viewer_fileUpload)){return()}else{read.csv(input$viewer_fileUpload$datapath)} },  
                                   striped = TRUE,  
                                   hover = TRUE)

  # end obsBrainPlot3
  
  
}

  