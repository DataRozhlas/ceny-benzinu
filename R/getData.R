natural  <- read.csv("../data/natural-okresy.csv", stringsAsFactors=F)
nafta  <- read.csv("../data/nafta-okresy.csv", stringsAsFactors=F)

natural  <- tbl_df(natural)
nafta  <- tbl_df(nafta)

nafta  <- nafta %>%
        select(NAZEV, AKTUALIZAC, NAFTA=CENA, JMENO, NAZEV_2, NAZKR, NUTS4)

natural  <- natural %>%
        select(NAZEV, AKTUALIZAC, NATURAL=CENA, JMENO, NAZEV_2, NAZKR, NUTS4)


vse  <- left_join(nafta, natural)
