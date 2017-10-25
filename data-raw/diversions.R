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
         `Antelope Creek` = (C11307 / (C11307 + C11308 + C11309) * D11305) / C11307,
         `Battle Creek` = NA,
         `Bear Creek` = NA,
         `Big Chico Creek` = NA,
         `Butte Creek` = (C217B + D217) / (C217B + D217 + C217A),
         `Clear Creek` = NA,
         `Cottonwood Creek` = NA,
         `Cow Creek` = NA,
         `Deer Creek` = (C11309 / (C11307 + C11308 + C11309) * D11305) / C11309,
         `Elder Creek` = (C11303 / (C11303 + C11304) * D11301) / C11303,
         `Mill Creek` = (C11308 / (C11307 + C11308 + C11309) * D11305) / C11308,
         `Paynes Creek` = NA,
         `Stony Creek` = D17301 / C42,
         `Thomes Creek` = (C11304 / (C11303 + C11304) * D11301) / C11304,
         `Upper-mid Sacramento River` = (D109 + D112 + D113A + D113B + D114 + D118 + D122A + D122B
                                         # + D122_EWA  #not in baseline calsim run
                                         # + D122_WTS  #not in baseline calsim run
                                         # + D128_EWA  #not in baseline calsim run
                                         + D123 + D124A + D128_WTS + D128) / C110,
         `Sutter Bypass` = NA,
         `Bear River` = D285 / (C285 + D285),
         `Feather River` = (D201 + D202 + D7A + D7B) / C6,
         `Yuba River` = D230 / (C230 + D230),
         `Lower-mid Sacramento River` = (D129A + D134 + D162 + D163 + D165) / C128, # D165A does not exist
         `Yolo Bypass` = NA,
         `American River` = D302 / C9,
         `Lower Sacramento River` = (D167 + D168 + D168A_WTS) / C166,
         `Calaveras River` = (D506A + D506B + D506C + D507) / C92,
         `Cosumnes River` = NA,
         `Mokelumne River` = NA, # waiting on other run from mike U
         `Merced River` = (D562 + D566) / C561,
         `Stanislaus River` = D528 / C520,
         `Tuolumne River` = D545 / C540,
         `San Joaquin River` = (D637 + D630B + D630A + D620B) / (D637 + D630B + D630A + D620B + C637)) %>%
  select(date, watersheds)

#fix prop_div > 1 or inf or nan
proportion_diverted <- temp_diver %>%
  gather(watershed, prop_diver, -date) %>%
  mutate(prop_diver = round(prop_diver, 6),
         prop_diver = case_when(
           is.infinite(prop_diver) ~ 0,
           is.nan(prop_diver) ~ 0,
           prop_diver > 1 ~ 1,
           TRUE ~ prop_diver
         )) %>%
  spread(watershed, prop_diver) %>%
  select(date, watersheds)

use_data(proportion_diverted, overwrite = TRUE)

# diagnostic plots and solutions for prop_div > 1 or inf or nan-----------------------------------
  #yuba div/div+flow is solution
  div_calsim %>%
    select(date, C230, D230) %>%
    mutate(C231 = C230 + D230) %>%
    select(-C230) %>%
    gather(node, flow, -date) %>%
    ggplot(aes(x = date, y = flow, color = node)) +
    geom_line()
    mutate(prop_div = round(D230/C230, 6)) %>% View()

    #merced cap prop div to 1
    div_calsim %>%
      select(date, D562, D566, C561) %>%
      mutate(diver = D562 + D566) %>%
      select(date, C561, diver) %>%
      filter(year(date) >= 1980, year(date) < 2000, month(date) < 9) %>%
      gather(node, flow, -date) %>%
      ggplot(aes(x = date, y = flow, fill = node)) +
      geom_col(position = 'dodge')

    #butte creek sum(C217B, D217)/sum(C217A, C217B, D217)
    div_calsim %>%
      select(date, C217A, C217B, D217) %>%
      mutate(diver = C217B + D217) %>%
      select(date, C217A, diver) %>%
      filter(year(date) >= 1980, year(date) < 2000, month(date) < 9) %>%
      gather(node, flow, -date) %>%
      ggplot(aes(x = date, y = flow, fill = node)) +
      geom_col(position = 'dodge')

    #bear river div/div+flow is solution

    #calaveras cap prop div to 1
    div_calsim %>%
      select(date, C92, D506A, D506B, D506C, D507) %>%
      mutate(diver = D506A + D506B + D506C + D507) %>%
      select(date, C92, diver) %>%
      filter(year(date) >= 1980, year(date) < 2000, month(date) < 9) %>%
      gather(node, flow, -date) %>%
      ggplot(aes(x = date, y = flow, fill = node)) +
      geom_col(position = 'dodge')

    # elder and thomes cap prop div to 1 and sum their flows instead of combined node
    div_calsim %>%
      select(date, elder_flow = C11303,  thomes_flow = C11304, combined_diver = D11301,
             C11301) %>%
      mutate(combined_flow = elder_flow + thomes_flow) %>%
      filter(year(date) >= 1980, year(date) < 2000, month(date) < 9, combined_flow < combined_diver) %>% View()
