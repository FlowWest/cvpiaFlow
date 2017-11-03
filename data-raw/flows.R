library(tidyverse)
library(lubridate)
library(devtools)
library(readxl)
library(stringr)

calsim <- read_rds('data-raw/MikeWrightCalSimOct2017/cvpia_calsim.rds')
cvpia_nodes <- read_csv('data-raw/MikeWrightCalSimOct2017/cvpia_calsim_nodes.csv', skip = 1)
watersheds <- cvpia_nodes$watershed

need_split <- cvpia_nodes$calsim_habitat_flow %>% str_detect(', ')
habitat_split <- cvpia_nodes$calsim_habitat_flow[need_split] %>% str_split(', ') %>% flatten_chr()
habitat_node <- c(cvpia_nodes$calsim_habitat_flow[!need_split], habitat_split, 'C134', 'C160')[-20]

node_columns <- names(calsim) %in% c(habitat_node, 'date')

flow_calsim <- calsim[, node_columns]

flow <- flow_calsim %>%
  mutate(`Upper Sacramento River` = C104,
         `Antelope Creek` = C11307,
         `Battle Creek` = C10803,
         `Bear Creek` = C11001,
         `Big Chico Creek` = C11501,
         `Butte Creek` = C217A,
         `Clear Creek` = C3,
         `Cottonwood Creek` = C10802,
         `Cow Creek` = C10801,
         `Deer Creek` = C11309,
         `Elder Creek` = C11303,
         `Mill Creek` = C11308,
         `Paynes Creek` = C11001,
         `Stony Creek` = C142A,
         `Thomes Creek` = C11304,
         `Upper-mid Sacramento River` = C115,
         `Sutter Bypass` = D117 + D124 + D125 + D126,
         `Bear River` = C285,
         `Feather River` = C203,
         `Yuba River` = C230,
         `Lower-mid Sacramento River1` = C134, # low-mid habitat = 35.6/58*habitat(C134) + 22.4/58*habitat(C160),
         `Lower-mid Sacramento River2` = C160,
         `Yolo Bypass` = C157,
         `American River` = C9,
         `Lower Sacramento River` = C166,
         `Calaveras River` = C92,
         `Cosumnes River` = C501,
         # `Mokelumne River` = NA,
         `Merced River` = C561,
         `Stanislaus River` = C520,
         `Tuolumne River` = C540,
         `San Joaquin River` = C630) %>%
  select(date, `Upper Sacramento River`:`San Joaquin River`)

# testing Moke flows from exteranl model to calsim II - C503 vs 04-501
moke_test <- read_excel('data-raw/EBMUDSIM/CVPIA_SIT_Data_RequestEBMUDSIMOutput_ExCond.xlsx', sheet = 'Tableau Clean-up') %>%
  mutate(date = as_date(Date), C503) %>%
  select(date, C503)

c501_504 <- read_csv('data-raw/MikeWrightCalSimOct2017/C422-C843.csv', skip = 1) %>%
  select(date = X2, C504, C501) %>%
  filter(!is.na(date)) %>%
  mutate(date = dmy(date))

moke_test %>%
  left_join(c501_504) %>%
  mutate(calsim = as.numeric(C504) - as.numeric(C501)) %>%
  select(date, ebmudsim = C503, calsim) %>%
  gather(model, flow, -date) %>%
  filter(year(date) >= 1980, year(date) < 2000) %>%
  ggplot(aes(x = date, y = flow, color = model)) +
  geom_line() +
  theme_minimal() +
  theme(text = element_text(size = 18))
#looks great

# bring in Moke flow from other model run
moke <- read_excel('data-raw/EBMUDSIM/CVPIA_SIT_Data_RequestEBMUDSIMOutput_ExCond.xlsx', sheet = 'Tableau Clean-up') %>%
  mutate(date = as_date(Date), `Mokelumne River` = C91) %>%
  select(date, `Mokelumne River`)

flows <- flow %>%
  left_join(moke) %>%
  select(date:`Cosumnes River`, `Mokelumne River`, `Merced River`:`San Joaquin River`)


use_data(flows)

# retQ----------------------------
# proportion flows at tributary junction coming from natal watershed using october average flow

# create lookup vector for retQ denominators based on Jim's previous input
denominators <- c(rep(watersheds$watershed[16], 16), NA, watersheds$watershed[19], watersheds$watershed[21], watersheds$watershed[19],
                  watersheds$watershed[21], NA, rep(watersheds$watershed[24],2), watersheds$watershed[25:27], rep(watersheds$watershed[31],4))

names(denominators) <- watersheds$watershed

dens <- flows %>%
  select(-`Lower-mid Sacramento River1`) %>% #Feather river comes in below Fremont Weir use River2 for Lower-mid Sac
  rename(`Lower-mid Sacramento River` = `Lower-mid Sacramento River2`) %>%
  gather(watershed, flow, -date) %>%
  filter(month(date) == 10, watershed %in% unique(denominators)) %>%
  rename(denominator = watershed, den_flow = flow)

return_flow <- flows %>%
  select(-`Lower-mid Sacramento River1`) %>% #Feather river comes in below Fremont Weir use River2 for Lower-mid Sac
  rename(`Lower-mid Sacramento River` = `Lower-mid Sacramento River2`) %>%
  gather(watershed, flow, -date) %>%
  filter(month(date) == 10) %>%
  mutate(denominator = denominators[watershed]) %>%
  left_join(dens) %>%
  mutate(retQ = ifelse(flow / den_flow > 1, 1, flow / den_flow),
         retQ = replace(retQ, watershed %in% c('Calaveras River', 'Cosumnes River', 'Mokelumne River'), 1)) %>%
  select(watershed, date, retQ) %>%
  spread(date, retQ) %>%
  left_join(watersheds) %>%
  arrange(order) %>%
  select(-order)

View(return_flow)

devtools::use_data(return_flow, overwrite = TRUE)

return_flow %>%
  select(watershed, starts_with('198'), starts_with('199')) %>% View()

# delta flows--------------------
# North Delta inflows: C400 + C157
# South Delta inflow: C401B + C504 + C508 + C644
delta_inflow <- cvpia_calsim %>%
  select(date, C400, C157, C401B, C504, C508, C644) %>%
  mutate(north_delta_inflow = C400 + C157,
         south_delta_inflow = C401B + C504 + C508 + C644) %>%
  filter(!is.na(north_delta_inflow)) %>%
  select(date, north_delta_inflow, south_delta_inflow)




# North Delta diversions: D403A + D403B + D403C + D403D + D404
# South Delta diversions: D418 + D419 + D412 + D410 + D413 + 409B + D416 + D408_OR + D408_VC
