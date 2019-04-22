library('shiny')       # загрузка пакетов
library('lattice')
library('plyr')
library('data.table')
file.URL <- 'https://raw.githubusercontent.com/KseniaKubirikova/pract_3/laba3/Kinopoisk_2018.csv'
download.file(file.URL, destfile = 'Kinopoisk_2018.csv')
df <- data.table(read.csv('Kinopoisk_2018.csv', 
                          stringsAsFactors = F))

shinyServer(function(input, output) {
  output$text1 <- renderText({
    paste0('Вы выбрали оценку kinopoisk с ', 
           input$Rating.range[1], ' по ', input$Rating.range[2]
    )
  })
  output$text2 <- renderText({
    paste0('Вы выбрали оценку IMDB с ',
           input$Rating1.range[1], ' по ', input$Rating1.range[2]
    )
  })
  output$ds.text3 <- renderText({
    paste0('Вы выбрали продолжительность: ',
           input$ds.to.plot
    )
  })
  output$gn.text4 <- renderText({
    paste0('Всего фильмов - ', nrow(df)
    )
  })
  # строим гистограммы переменных
  output$hist1 <- renderPlot({
    # сначала фильтруем данные
    DF <- df[between(df$Kinopoisk.mark, input$Rating.range[1], input$Rating.range[2])]
    DF <- DF[between(DF$IMDb.mark, input$Rating1.range[1], input$Rating1.range[2])]
    DF <- df[df$Runtime == input$ds.to.plot, 1:7]
    
    output$text5 <- renderText({
      paste0('Отобранных фильмов - ', nrow(DF)
      )
    })
    
    # затем строим график
    histogram( ~ Cost, 
               data = DF,
               xlab = '',
               breaks = seq(min(DF$Cost), max(DF$Cost), 
                            length = input$int.hist + 1)
    )
  })
})