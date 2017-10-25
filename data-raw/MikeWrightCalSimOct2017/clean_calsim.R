library(tidyverse)
library(lubridate)
library(stringr)
library(devtools)

cvpia_nodes <- read_csv('data-raw/MikeWrightCalSimOct2017/cvpia_calsim_nodes.csv', skip = 1)
need_split <- cvpia_nodes$calsim_habitat_flow %>% str_detect(', ')
habitat_split <- cvpia_nodes$calsim_habitat_flow[need_split] %>% str_split(', ') %>% flatten_chr()
habitat_nodes <- c(cvpia_nodes$calsim_habitat_flow[!need_split], habitat_split, 'C134', 'C160')[-20]

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

pick_columns <- function(file, nodes) {
  temp <- read_csv(paste0('data-raw/MikeWrightCalSimOct2017/', file), skip = 1)
  ii <- names(temp) %in% nodes
  cleaned <- temp[6:nrow(temp),ii] %>%
    rename(date = X2) %>%
    mutate(date = dmy(date))
  return(cleaned)
}

file_names <- list.files('data-raw/MikeWrightCalSimOct2017/', '*.csv')[-5]

tt <- map_df(file_names, pick_columns, all_nodes)
cvpia_calsim <- tt %>%
  gather(node, flow, -date) %>%
  filter(!is.na(flow)) %>%
  mutate(flow = as.numeric(flow)) %>%
  spread(node, flow)

write_rds(cvpia_calsim, 'data-raw/MikeWrightCalSimOct2017/cvpia_calsim.rds')

# testing things to pick flow nodes------------------------------------
comparison_nodes <- c('C157', 'D160', 'D166A', 'D117', 'D124', 'D125', 'D126', 'C166', 'C165', 'X2', 'C134', 'C160')
ttt <- map_df(file_names, pick_columns, comparison_nodes)
testnodes <- ttt %>%
  gather(node, flow, -date) %>%
  filter(!is.na(flow)) %>%
  mutate(flow = as.numeric(flow)) %>%
  spread(node, flow)

# Yolo: C157 vs. D160+D166a (use C157)
testnodes %>%
  select(date, C157, D160, D166A) %>%
  mutate(`D160 + D166A` = D160 + D166A) %>%
  select(-D160, -D166A) %>%
  gather(nodes, flow, -date) %>%
  filter(year(date) >= 1980, year(date) < 1990) %>%
  ggplot(aes(x = date, y = flow, color = nodes)) +
  geom_line() +
  theme_minimal()

# Sutter: D117 vs. D124 Vs. D125 vs. D126
testnodes %>%
  select(date, D117, D124, D125, D126) %>%
  gather(spill, flow, -date) %>%
  filter(year(date) >= 1980, year(date) < 2000) %>%
  ggplot(aes(x = date, y = flow, fill = spill)) +
  geom_col(position = 'dodge') +
  # geom_col() +
  theme_minimal()

# Lower-Mid Sacramento: C160 vs. C134 (use both in proporition of stream length above and below fremont weir for habitat)
testnodes %>%
  select(date, C160, C134) %>%
  gather(nodes, flow, -date) %>%
  filter(year(date) >= 1980, year(date) < 2000) %>%
  ggplot(aes(x = date, y = flow, color = nodes)) +
  geom_line() +
  theme_minimal()

low_mid <- testnodes %>%
  select(date, C160, C134) %>%
  gather(nodes, flow, -date) %>%
  filter(year(date) >= 1980, year(date) < 2000)

library(cvpiaHabitat)
lower_mid_sacramento_river_floodplain %>% View()
lmfp <- lower_mid_sacramento_river_floodplain_approx('fr')

low_mid %>%
  mutate(floodplain = lmfp(flow)) %>%
  select(-flow) %>%
  spread(nodes, floodplain) %>%
  mutate(floodplain = 35.6/58*C134 + 22.4/58*C160) %>%
  ggplot(aes(x = date, y = floodplain)) +
  geom_col() +
  theme_minimal()

testnodes %>%
  select(date, D160, D166A) %>%
  gather(nodes, flow, -date) %>%
  filter(year(date) >= 1980, year(date) < 1990) %>%
  ggplot(aes(x = date, y = flow, fill = nodes)) +
  geom_col(position = 'dodge') +
  theme_minimal()
