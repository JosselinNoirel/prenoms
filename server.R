#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library('shiny')
library('rio')
library('tidyverse')
library('glue')
# library('scales')

theme_set(theme_bw())

furl = 'https://www.insee.fr/fr/statistiques/fichier/2540004/nat2021_csv.zip'
dat = rio::import(furl)

dat = dat %>% rename(sex=sexe, name=preusuel, year=annais, frequency=nombre)
dat = dat %>% mutate(sex=c('male', 'female')[sex],
                     year=as.integer(year))
dat = dat %>% mutate(length=str_length(name))
dat = dat %>% mutate(name=ifelse(name == '_PRENOMS_RARES', NA, name))
dat = dat %>% mutate(sex_name=paste(sex, name, sep=':'))

# Define server logic required to draw a histogram
shinyServer(function (input, output) {
    output$plot = renderPlot({
        name_list = strsplit(input$list, '\\s*,\\s*')[[1]]
        name_list = str_replace(name_list, ':\\s+', ':')

        dat %>% drop_na() %>%
            group_by(sex, year) %>%
            mutate(rfreq=frequency/sum(frequency)) %>%
            ungroup() %>%
            filter(name %in% name_list | sex_name %in% name_list) %>%
            ggplot(aes(year, 1000 * rfreq, colour=sex_name)) +
            geom_line(size=1) +
            xlab('Year') +
            ylab('Occurrences / 1000') +
            ylim(0, NA) +
            xlim(1899, 2024) +
            labs(colour='Names') +
            ggtitle(glue('Frequency of {input$list}'))
    })

    output$stats = renderTable({
        name_list = strsplit(input$list, '\\s*,\\s*')[[1]]
        name_list = str_replace(name_list, ':\\s+', ':')

        dat %>% drop_na() %>%
            # filter(year == 2020) %>%
            group_by(sex) %>%
            mutate(rfreq=1000 * frequency/sum(frequency),
                   rank=as.integer(rank(-frequency))) %>%
            ungroup() %>%
            filter(name %in% name_list | sex_name %in% name_list) %>%
            select(-sex_name)
    })
})
