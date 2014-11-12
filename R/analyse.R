library(dplyr)
library(stringr)


#okresy
nafta %>%
        select(NAZEV, NAFTA, JMENO, NAZEV_2, NUTS4) %>%
        group_by(NUTS4) %>%
        summarise(prumer = round(mean(NAFTA), 3), count=n(), min=min(NAFTA), max=max(NAFTA)) %>%
        arrange(prumer) %>%
        write.csv("../data/nafta-okresy.csv", row.names=F)

natural %>%
        select(NAZEV, NATURAL, JMENO, NAZEV_2, NUTS4) %>%
        group_by(NUTS4) %>%
        summarise(prumer = round(mean(NATURAL), 3), count=n(), min=min(NATURAL), max=max(NATURAL)) %>%
        arrange(prumer) %>%
        write.csv("../data/natural-okresy.csv", row.names=F)



#sítě
nafta %>%
        group_by(JMENO) %>%
        filter(n()>5) %>%
        summarise(prumer = mean(NAFTA), count=n()) %>%
        arrange(desc(prumer))

natural %>%
        group_by(JMENO) %>%
        filter(n()>5) %>%
        summarise(prumer = mean(NATURAL), count=n()) %>%
        arrange(desc(prumer))

# nejlevnější
nafta %>%
        select(NAZEV, NAFTA) %>%
        filter(NAFTA==39.9) %>%
        arrange(desc(NAFTA))

natural %>%
        select(NAZEV, NATURAL) %>%
        arrange(desc(NATURAL))

# export pro DataTables

output  <- vse %>%
        select(stanice=NAZEV, natural=NATURAL, diesel=NAFTA, okres=NAZEV_2, kraj=NAZKR)

output  <- output[complete.cases(output), ]

output$stanice  <- str_replace_all(output$stanice, "&amp;", "&")

write.csv(output, "../data/vse.csv", row.names=F)
