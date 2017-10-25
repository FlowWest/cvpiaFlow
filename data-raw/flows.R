library(tidyverse)
library(lubridate)
library(devtools)

calsim <- read_rds('data-raw/MikeWrightCalSimOct2017/cvpia_calsim.rds')
cvpia_nodes <- read_csv('data-raw/MikeWrightCalSimOct2017/cvpia_calsim_nodes.csv', skip = 1)
watersheds <- cvpia_nodes$watershed

need_split <- cvpia_nodes$calsim_habitat_flow %>% str_detect(', ')
habitat_split <- cvpia_nodes$calsim_habitat_flow[need_split] %>% str_split(', ') %>% flatten_chr()
habitat_node <- c(cvpia_nodes$calsim_habitat_flow[!need_split], habitat_split)
habitat_nodes <- habitat_node[!is.na(habitat_node)]

node_columns <- names(calsim) %in% c(habitat_node, 'date')

flow_calsim <- calsim[, node_columns]



