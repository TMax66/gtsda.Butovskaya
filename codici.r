library(here)
library(tidyverse)
library(openxlsx)
library(readxl)


dt <- read_excel(here("data", "raw", "fulldata.xlsx"))
coltivazioni <- read_excel(here("data", "raw", "tabcolt.xlsx"))

prov <- tibble(
  prov =c(  "Sondrio",
              "Como",
              "Varese",
              "Lecco",
              "Bergamo",
              "Brescia",
              "Pavia",
              "Lodi",
              "Milano",
              "Mantova",
              "Cremona"), 
  sup = c(319568,
          127902,
          119824,
          80560, 
          275486,
          478548, 
          296859,
          78297, 
          157549,
          234135, 
          177041)
)


gly <- tibble(
  prov = prov, 
  gly = c(0, 	0, 	0, 	5.88,	21.05,	22.22,	33.33, 33.33,	35.29,	53.85,	55.55)
)

lomb <- dt %>% 
  filter(Territorio %in% prov) %>% 
  left_join(
    coltivazioni, by = c("AGRI_MADRE")) %>% 
  filter(!is.na(`GRUPPO COLTIVAZIONE`))


#associazione %campioni pos a gly e % di territorio coltivato (indip dal tipo di coltivazione)
dt %>%  filter(Territorio %in% prov$prov) %>% 
  filter(`Tipo dato` == "superficie totale - ettari", 
         TIME %in% c(2020, 2021)) %>% 
  select(TIME, Territorio, Value) %>% 
  group_by(TIME, Territorio) %>% 
  summarise(Value = sum(Value)) %>% 
  pivot_wider(names_from = "TIME", values_from = "Value") %>% 
  left_join(
    prov, by = c("Territorio" = "prov")
  ) %>% 
  left_join(gly, by = c("Territorio" = "prov")) %>% 
  mutate('%terreni coltivati' = 100*((`2020`+`2021`)/2)/sup) %>%  
  
  ggplot()+
  aes(x = `%terreni coltivati`, y = gly, label = Territorio )+
  geom_point()+ geom_text()+
  geom_smooth()
  


















# cereali <- coltivazioni %>% 
#   filter(`GRUPPO COLTIVAZIONE` == "CEREALI E LEGUMI") %>% 
#   select(AGRI_MADRE) %>% 
#   unlist()
# frutta <- coltivazioni %>% 
#   filter(`GRUPPO COLTIVAZIONE` == "FRUTTA FRESCA E SECCA - ARBOREE") %>% 
#   select(AGRI_MADRE) %>% 
#   unlist()
# foragg <- coltivazioni %>% 
#   filter(`GRUPPO COLTIVAZIONE` == "FORAGGERE") %>% 
#   select(AGRI_MADRE) %>% 
#   unlist() 
# prati <- coltivazioni %>% 
#   filter(`GRUPPO COLTIVAZIONE` == "PRATI E PASCOLI") %>% 
#   select(AGRI_MADRE) %>% 
#   unlist() 


# lomb <- dt %>% 
#   filter(Territorio %in% prov) %>% 
#   mutate(gruppocolt = ifelse(AGRI_MADRE %in% c(cereali), "cereali e legumi",
#           ifelse(AGRI_MADRE %in% c(frutta), "frutta e arboree", 
#                  ifelse(AGRI_MADRE %in% c(foragg), "foraggere",
#                         ifelse(AGRI_MADRE %in% c(prati), "pratie pascoli", AGRI_MADRE))))) %>%  
#   filter(gruppocolt %in% c("cereali e legumi", "frutta e arboree", "foraggere", "prati e pascoli"), 
#          TIME %in% c(2020, 2021)) %>% View()

