getHistory  <- function() {
        require(rvest)
        require(XML)
        require(stringr)
        roky  <- c("2009", "2010", "2011", "2012", "2013", "2014")
        output  <- character()
        for(i in roky) {
                url  <- paste0("http://www.czso.cz/csu/csu.nsf/kalendar/", i, "-tdb")
                zdrojak  <- htmlParse(url)
                links  <- zdrojak %>%
                        html_nodes(".out") %>%
                        html_attr("href")
                links  <- links[grepl("/csu/csu.nsf/informace/", links)]
                output  <- append(output, links)
                
        }
        for(i in output) {
             url  <- paste0("http://www.czso.cz", i)
             zdrojak  <- htmlParse(url)
             link  <- zdrojak %>%
                     html_node("tr:nth-child(1) a") %>%
                     html_attr("href")
             url  <- paste0("http://www.czso.cz" ,link)
             filename  <- str_sub(link, -11, -1)
             download.file(url, paste0("../data/historie/", filename))
        }
}




