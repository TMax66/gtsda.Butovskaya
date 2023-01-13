## Provo ad aggiungere un esempio per vedere se funziona tutto


library(here)
library(tidyverse)
library(lubridate)
library(odbc)
library(DBI)
library(rgeos)
library(rmapshaper)
library(raster)
library(rgdal)
library(sp)
library(leaflet)
library(maps)
library(readxl)
library(openxlsx)
library(DT)
library(gt)
library(tmap)
library(GADMTools)
library(tmaptools)
library(stringr)


##connessione dbase IZSLER (bobj) per estrazione dati----
# con <- DBI::dbConnect(odbc::odbc(), Driver = "SQL Server", Server = "dbprod02.izsler.it",
#                           Database = "IZSLER", Port = 1433)
# 
# data <- dbGetQuery(con, query)
# 
# 
# 
# ## sql----
# source(here("ETL", "sql.r"))
# 
# ## estrazione dati----
# dati <- con%>% tbl(sql(query)) %>% as_tibble()
# 
# saveRDS(dati, here("data", "processed", "dati.RDS"))

dt <- readRDS(here("data", "processed", "dati.RDS"))

## preparazione dataset
dt <- dt %>% 
  filter(!finalita %in% c("Autocontrollo", "Progetto: PRC2014010", "Esame batteriologico MSU", "PNR Sospetto MSU") ) %>% 
  mutate(matrice = recode(matrice, 
                          "MUSCOLO DI BOVINO ADULTO" = "MUSCOLO DI BOVINO", 
                          "MUSCOLO DI VITELLO" = "MUSCOLO DI BOVINO", 
                          "MUSCOLO DI VITELLONE" = "MUSCOLO DI BOVINO",
                          "MUSCOLO DI SUINO DA INGRASSO" = "MUSCOLO DI SUINO", 
                          "MUSCOLO DI SUINO LATTONZOLO/MAGRONE/MAGRONCELLO" = "MUSCOLO DI SUINO", 
                          "MUSCOLO DI SUINO RIPRODUTTORE FEMMINA" = "MUSCOLO DI SUINO", 
                          "MUSCOLO DI SUINO RIPRODUTTORE MASCHIO" = "MUSCOLO DI SUINO", 
                          "MUSCOLO DI SUINO LATTONZOLO/MAGRONE/MAGRONCELLO" =  "MUSCOLO DI SUINO"), 
         nconf = paste0(anno, "/", nconf),
         PosAB = ifelse(Tecnica == "LC-MS/MS" & esiti == "Irr/Pos", 1, 
                        ifelse(!is.na(valore), 1, 0)), 
         month = month(dtprel),
         Ymonth = paste0(anno,"-", month))


#### ricodifica categorie matrici----

 dt %>% 
  filter(!finalita %in% c("Autocontrollo", "Progetto: PRC2014010", "Esame batteriologico MSU", "PNR Sospetto MSU") ) %>% 
  mutate(matrice = recode(matrice, 
                          "MUSCOLO DI BOVINO ADULTO" = "MUSCOLO DI BOVINO", 
                          "MUSCOLO DI VITELLO" = "MUSCOLO DI BOVINO", 
                          "MUSCOLO DI VITELLONE" = "MUSCOLO DI BOVINO",
                          "MUSCOLO DI SUINO DA INGRASSO" = "MUSCOLO DI SUINO", 
                          "MUSCOLO DI SUINO LATTONZOLO/MAGRONE/MAGRONCELLO" = "MUSCOLO DI SUINO", 
                          "MUSCOLO DI SUINO RIPRODUTTORE FEMMINA" = "MUSCOLO DI SUINO", 
                          "MUSCOLO DI SUINO RIPRODUTTORE MASCHIO" = "MUSCOLO DI SUINO", 
                          "MUSCOLO DI SUINO LATTONZOLO/MAGRONE/MAGRONCELLO" =  "MUSCOLO DI SUINO"), 
         nconf = paste0(anno, "/", nconf),
         PosAB = ifelse(Tecnica == "LC-MS/MS" & esiti == "Irr/Pos", 1, 
                        ifelse(!is.na(valore), 1, 0)), 
         month = month(dtprel),
         Ymonth = paste0(anno,"-", month)) %>%  
 group_by(matrice, anno,nconf, dtprel, ) %>% 
  summarise(sAB = sum(PosAB, na.rm = TRUE)) %>%     
  # distinct(nconf, .keep_all = TRUE) %>% 
  #group_by(matrice, anno, Ymonth) %>% 
  #count() %>%
  group_by(matrice,month = floor_date(dtprel, 'month')) %>% 
  mutate(posAB = ifelse(sAB >= 1, 1, 0)) %>% 
  group_by(matrice, month) %>% 
  summarise(confP = sum(posAB), 
            n = n()) %>%  
  mutate(P = round(100*(confP/n), 2)) %>%   
  ggplot()+
  aes(x = month, y = P)+
  geom_point()+
  geom_line(group = 1)+ geom_smooth()+
  facet_wrap(. ~ matrice, scales = "free")+
  theme_bw()+ labs(y = "% di conferimenti con presenza di residui di antibiotico")




## n.pos per comune x anno


## mappe
# ita <- getData("GADM", country = "ITA", level = 0)
# reg <- getData("GADM", country = "ITA", level = 1)
# prov <- getData("GADM", country = "ITA", level = 2)
# com <- getData("GADM", country = "ITA", level = 3)

#com <- readRDS(here("data", "geo", "gadm36_ITA_3_sp.rds"))

com   <- GADMTools::gadm_sf_loadCountries("ITA", level=3,basefile = "data/")$sf
reg   <-  GADMTools::gadm_sf_loadCountries("ITA", level=1,basefile = "data/")$sf
prov   <-GADMTools::gadm_sf_loadCountries("ITA", level=2,basefile = "data/")$sf

com <- readRDS(here( "data","ITA_adm3.sf.rds"))
prov <- readRDS(here( "data","ITA_adm2.sf.rds"))
reg <- readRDS(here( "data","ITA_adm1.sf.rds"))
# leaflet() %>% 
#   addTiles() %>% 
#   addPolygons(data = lo, stroke = TRUE, fill = FALSE) %>% 
#   addPolygons(data = er, stroke = TRUE, fill =  FALSE) 
# ## pos x comune



#comuni <- unique(factor(pos_com$comune))

 
pos_com <- dt %>% 
  filter(!comune %in% c("Non Definito")) %>% 
  group_by(matrice, nconf, dtprel, comune ) %>% 
  summarise(sAB = sum(PosAB, na.rm = TRUE)) %>%  
  group_by(matrice,  comune) %>% 
  mutate(posAB = ifelse(sAB >= 1, 1, 0)) %>%  
  summarise(confP = sum(posAB, na.rm = TRUE), 
            n = n()) %>%  
  mutate(P = round(100*(confP/n), 2)) %>% 
  mutate(comune = str_replace_all(comune, fixed(" "), ""), 
         comune = casefold(comune, upper = FALSE)) %>% 
  filter(matrice == "MUSCOLO DI BOVINO")    

regioni <- c("Lombardia", "Emilia-Romagna")
REG <- reg %>% filter(NAME_1 %in% regioni)
mapPr<- com %>%
  filter(NAME_1 %in% regioni ) %>% 
  mutate(NAME_3 = str_replace_all(NAME_3, fixed(" "), ""),
         NAME_3 = casefold(NAME_3, upper = FALSE)) %>% 
  left_join(pos_com, by = c("NAME_3" = "comune")) %>% 
  group_by(matrice, NAME_2) %>% 
  summarise(confP = sum(confP, na.rm = TRUE), 
            n = sum(n , na.rm = TRUE))%>%  
  mutate(P = round(100*(confP/n), 2))  

tm_shape(mapPr)+tm_fill("P", colorNA = "white")+tm_borders(col = "blue")+
  tm_shape(REG)+tm_borders("black")+ tm_fill("white", alpha = 0.001)+ tm_borders("black")+
  
  tm_layout(main.title = " % di campioni di muscolo bovino con presenza di residui di AB nel periodo 2018-2022",
            main.title.size = 0.95,
            legend.title.size = 1,
            legend.text.size = 0.5,
            legend.position = c("right","top"),
            legend.bg.color = "white",
            legend.bg.alpha = 1)+
  tm_scale_bar(breaks = c(0, 50, 100), text.size = .5,position = "left")+
  tm_compass(type = "8star", position = c("right", "bottom"), size =  1) +
 ")

   
