library(tidyverse)
library(lubridate)
library(stringr)
library(devtools)

cvpia_nodes <- read_csv('data-raw/MikeWrightCalSimOct2017/cvpia_calsim_nodes.csv', skip = 1)
need_split <- cvpia_nodes$calsim_habitat_flow %>% str_detect(', ')
habitat_split <- cvpia_nodes$calsim_habitat_flow[need_split] %>% str_split(', ') %>% flatten_chr()
habitat_node <- c(cvpia_nodes$calsim_habitat_flow[!need_split], habitat_split)
habitat_nodes <- habitat_node[!is.na(habitat_node)]


need_split <- cvpia_nodes$cal_sim_flow_nodes %>% str_detect(', ')
div_split <- cvpia_nodes$cal_sim_flow_nodes[need_split] %>% str_split(', ') %>% flatten_chr()
div_flow_nodes <- c(cvpia_nodes$cal_sim_flow_nodes[!need_split], div_split)

need_split <- cvpia_nodes$cal_sim_diversion_nodes %>% str_detect(', ')
div_split <- cvpia_nodes$cal_sim_diversion_nodes[need_split] %>% str_split(', ') %>% flatten_chr()
div_nodes <- c(cvpia_nodes$cal_sim_diversion_nodes[!need_split], div_split)
diversion_nodes <- div_nodes[!is.na(div_nodes)] %>% str_trim('both') %>% str_replace(',', '')

combined_flow_nodes <- c('C11305', 'C11301')
#combine all nodes to select columns
all_nodes <- c(habitat_nodes, div_flow_nodes, diversion_nodes, combined_flow_nodes, 'X2') %>% unique()

pick_columns <- function(file) {
  temp <- read_csv(paste0('data-raw/MikeWrightCalSimOct2017/', file), skip = 1)
  ii <- names(temp) %in% all_nodes
  cleaned <- temp[6:nrow(temp),ii] %>%
    rename(date = X2) %>%
    mutate(date = dmy(date))
  return(cleaned)
}

file_names <- list.files('data-raw/MikeWrightCalSimOct2017/', '*.csv')[-5]

tt <- map_df(file_names, pick_columns)
cvpia_calsim <- tt %>%
  gather(node, flow, -date) %>%
  filter(!is.na(flow)) %>%
  mutate(flow = as.numeric(flow)) %>%
  spread(node, flow)

write_rds(cvpia_calsim, 'data-raw/MikeWrightCalSimOct2017/cvpia_calsim.rds')


