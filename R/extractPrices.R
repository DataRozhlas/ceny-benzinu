extractPrices  <- function() {
        library(xlsx)
        library(stringr)
        
        output  <- data.frame(rok=integer(), tyden=integer(), natural=numeric(), nafta=numeric(), lpg=numeric())
        soubory1  <- list.files("../data/historie/", "*.xlsx")
        soubory2  <- list.files("../data/historie/", "*.xls$")
        
        for (i in soubory1) {
                ceny  <- as.numeric(as.character(read.xlsx(paste0("../data/historie/", i), 1)[c(8,10,12),3]))
                rok  <- as.numeric(paste0("20", str_sub(i, 5, 6)))
                tyden  <- as.numeric(str_sub(i, 3, 4))
                output  <- rbind(output, data.frame(rok, tyden, natural=ceny[1], nafta=ceny[2], lpg=ceny[3]))
        }
        
        for (i in soubory2) {
                ceny  <- as.numeric(as.character(read.xlsx(paste0("../data/historie/", i), 1)[c(10,12,14),3]))
                rok  <- as.numeric(paste0("20", str_sub(i, 6, 7)))
                tyden  <- as.numeric(str_sub(i, 4, 5))
                if (is.na(ceny[1])) {
                        ceny  <- as.numeric(as.character(read.xlsx(paste0("../data/historie/", i), 1)[c(6,7,8),3]))
                } 
                output  <- rbind(output, data.frame(rok, tyden, natural=ceny[1], nafta=ceny[2], lpg=ceny[3]))
        }
        
        return(output)
}