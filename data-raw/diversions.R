library(tidyverse)

calsim <- read_rds('data-raw/MikeWrightCalSimOct2017/cvpia_calsim.rds')
cvpia_nodes <- read_csv('data-raw/MikeWrightCalSimOct2017/cvpia_calsim_nodes.csv', skip = 1)
View(cvpia_nodes)
watersheds <- cvpia_nodes$watershed

need_split <- cvpia_nodes$cal_sim_flow_nodes %>% str_detect(', ')
div_split <- cvpia_nodes$cal_sim_flow_nodes[need_split] %>% str_split(', ') %>% flatten_chr()
div_flow_nodes <- c(cvpia_nodes$cal_sim_flow_nodes[!need_split], div_split)

need_split <- cvpia_nodes$cal_sim_diversion_nodes %>% str_detect(', ')
div_split <- cvpia_nodes$cal_sim_diversion_nodes[need_split] %>% str_split(', ') %>% flatten_chr()
div_nodes <- c(cvpia_nodes$cal_sim_diversion_nodes[!need_split], div_split)
diversion_nodes <- div_nodes[!is.na(div_nodes)] %>% str_trim('both') %>% str_replace(',', '')

combined_flow_nodes <- c('C11305', 'C11301')

all_div_nodes <- c(div_flow_nodes, diversion_nodes, combined_flow_nodes, 'date') %>% unique()
all_div_nodes
node_columns <- names(calsim) %in% all_div_nodes
div_calsim <- calsim[, node_columns]

temp_diver <- div_calsim %>%
  mutate(`Upper Sacramento River` = D104 / C104,
         `Antelope Creek` = (C11307 / C11305 * D11305) / C11307,
         `Battle Creek` = NA,
         `Bear Creek` = NA,
         `Big Chico Creek` = NA,
         `Butte Creek` = (C217B + D217) / C217A,
         `Clear Creek` = NA,
         `Cottonwood Creek` = NA,
         `Cow Creek` = NA,
         `Deer Creek` = (C11309 / C11305 * D11305) / C11309,
         `Elder Creek` = (C11303 / C11301 * D11301) / C11303,
         `Mill Creek` = (C11308 / C11305 * D11305) / C11308,
         `Paynes Creek` = NA,
         `Stony Creek` = D17301 / C42,
         `Thomes Creek` = (C11304 / C11301 * D11301) / C11304,
         # `Upper-mid Sacramento River` = (D109 + D112 + D113A + D113B + D114 + D118 + D122A +
         #                                   D122B + D122_EWA + D122_WTS + D123 + D124A + D128_EWA
         #                                 + D128_WTS + D128) / C110,
         `Sutter Bypass` = NA,
         `Bear River` = D285 / C285,
         `Feather River` = (D201 + D202 + D7A + D7B) / C6,
         `Yuba River` = D230 / C230,
         # `Lower-mid Sacramento River` = (D129A + D134 + D162 + D163 + D165 + D165A) / C128,
         `Yolo Bypass` = NA,
         `American River` = D302 / C9,
         `Lower Sacramento River` = (D167 + D168 + D168A_WTS) / C166,
         `Calaveras River` = (D506A + D506B + D506C + D507) / C92,
         `Cosumnes River` = NA,
         # `Mokelumne River` = (D502A + D502B + D503A + D503B + D503C + D504) / C91,
         `Merced River` = (D562 + D566) / C561,
         `Stanislaus River` = D528 / C520,
         `Tuolumne River` = D545 / C540,
         `San Joaquin River` = (D637 + D630B + D630A + D620B) / (D637 + D630B + D630A + D620B + C637)) %>%
  select(date, watersheds[c(-16, -21, -27)])

temp_diver %>%
  gather(watershed, prop_diver, -date) %>%
  mutate(prop_diver = round(prop_diver, 6),
         prop_diver = ifelse(is.infinite(prop_diver), 0, prop_diver)) %>%
  spread(watershed, prop_diver) %>% View()
