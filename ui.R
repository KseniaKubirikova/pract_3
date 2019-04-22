library('shiny')       # загрузка пакетов
library('data.table')

file.URL <- 'https://raw.githubusercontent.com/KseniaKubirikova/pract_3/laba3/Kinopoisk_2018.csv'
download.file(file.URL, destfile = 'Kinopoisk_2018.csv')
df <- data.table(read.csv('Kinopoisk_2018.csv', 
                          stringsAsFactors = F))
ds.filter <- as.character(unique(df$Runtime))
names(ds.filter) <- ds.filter
ds.filter <- as.list(ds.filter)

# размещение всех объектов на странице
shinyUI(
  # создать страницу с боковой панелью
  # и главной областью для отчётов
  pageWithSidebar(
    # название приложения:
    headerPanel('Бюджет фильмов на портале Kinopoisk за 2018 год'),
    # боковая панель:
    sidebarPanel(
      selectInput('ds.to.plot','Выберите продолжительность',ds.filter),
      sliderInput('Rating.range', 'Оценка кинопоиска:',
                  min = min(df$Kinopoisk.mark), max = max(df$Kinopoisk.mark), value = c(min(df$Kinopoisk.mark), max(df$Kinopoisk.mark))),
      sliderInput('Rating1.range', 'Оценка IMDB:',
                  min = min(df$IMDb.mark), max = max(df$IMDb.mark), value = c(min(df$IMDb.mark), max(df$IMDb.mark))),
      
      
      sliderInput(               # слайдер: кол-во интервалов гистограммы
        'int.hist',                       # связанная переменная
        'Количество интервалов гистограммы:', # подпись
        min = 2, max = 10,                    # мин и макс
        value = floor(1 + log(50, base = 2)), # базовое значение
        step = 1)                             # шаг
    ),
    # главная область
    mainPanel(
      # текстовый объект для отображения
      textOutput('text1'),
      textOutput('text2'),
      textOutput('text3'),
      textOutput('text4'),
      textOutput('text5'),
      # гистограммы переменных
      plotOutput('hist1')
    )
  )
)