library(tidyverse)
library(lubridate)
library(devtools)

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
         `Mokelumne River` = NA,
         `Merced River` = C561,
         `Stanislaus River` = C520,
         `Tuolumne River` = C540,
         `San Joaquin River` = C630) %>%
  select(date, `Upper Sacramento River`:`San Joaquin River`)

use_data(flow)
