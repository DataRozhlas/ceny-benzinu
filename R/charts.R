# formátování dat
load(ceny, file="../data/historie/prumerne_ceny.R")
ceny  <- cbind(datum=as.Date(paste(ceny$rok, ceny$tyden, 1), format = "%Y %U %u"), ceny)


# graf 1: historický vývoj cen
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(lubridate)

ceny  <- tbl_df(ceny)

ceny2  <- ceny %>%
        select(datum, natural, nafta, lpg) %>%
        gather(palivo, cena, natural:lpg)

ggplot(ceny2, aes(x=datum, y=cena, colour=palivo)) + geom_line()

py <- plotly()
py$ggplotly()

# graf 2: z čeho se skládá cena

zkusRok  <- function(rok) {if (rok < 2010) {return(19)
} else if (rok > 2012) {return(21)
} else {return(20)}
}

zkusRok2  <- function(rok) {if (rok < 2010) {return(11.84)
} else {return(12.84)}
}

year(ceny$datum)

brent  <- read.csv("../data/BRENT.csv", header=F)
brent  <- tbl_df(brent)
brent  <- brent %>%
        mutate(datum=as.Date(V1)) %>%
        select(datum, brent=V2)

usd  <- read.csv("../data/USD.csv", stringsAsFactors=F)
usd  <- tbl_df(usd)
usd  <- usd %>%
        mutate(datum=as.Date(Datum, format="%d.%m.%Y")) %>%
        select(datum, usd=Kurz) %>%
        mutate(usd=as.numeric(str_replace(usd, ",", ".")))



ceny3  <- ceny %>%
        mutate(sazba = sapply(rok, zkusRok)) %>%
        mutate(spotrebni = sapply(rok, zkusRok2)) %>%
        mutate(dph = natural/(100+sazba)*sazba) %>%
        select(datum, natural, dph, spotrebni)
        


ceny3  <- left_join(ceny3, brent)

ceny3  <- left_join(ceny3, usd)

ceny3 <- ceny3 %>%
        arrange(datum)

ceny4  <- ceny3 %>%
        mutate(ropa=brent*usd/150,
               marze=natural-dph-spotrebni-ropa)

ceny5  <- ceny4 %>%
        select(datum, spotrebni, dph, ropa, marze) %>%
        gather(slozka, castka, spotrebni:marze)
        
ggplot(ceny5, aes(x=datum, y=castka, fill=slozka)) + geom_area()

ceny5 <- ceny4 %>%
        mutate(
                spotrebni=spotrebni,
                dph=dph+spotrebni,
                ropa=dph+ropa,
                marze=ropa+marze) %>%
        select(datum, spotrebni, dph, ropa, marze)


write.csv(ceny5, "areachart.csv", row.names=F)

py2 <- plotly()
py2$ggplotly()

ceny4 %>%
        arrange(desc(marze)) %>%
        slice(1:100)

output  <- ceny4 %>%
        select(datum, brent)

write.csv(t(output), "output.csv", row.names=F)

ceny4 %>%
        arrange(brent) %>%
        slice(1:100)

