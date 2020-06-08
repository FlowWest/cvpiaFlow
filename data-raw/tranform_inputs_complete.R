library(dplyr)
library(tidyr)
library(readr)
library(lubridate)
library(stringr)
library(readxl)

source('R/utils.R')
# tributary --------------

prop_diversion <- cvpiaFlow::proportion_diverted %>%
  filter(year(date) >= 1980, year(date) <= 2000) %>%
  gather(watershed, prop_diver, -date) %>%
  mutate(prop_diver = ifelse(is.na(prop_diver), 0, prop_diver)) %>%
  spread(date, prop_diver) %>%
  left_join(cvpiaData::watershed_ordering) %>%
  arrange(order) %>%
  select(-watershed, -order) %>%
  create_SIT_array()

dim(prop_diversion)

# usethis::use_data(prop_diversion, overwrite = TRUE)

calsim <- read_rds('data-raw/MikeWrightCalSimOct2017/cvpia_calsim.rds')
cvpia_nodes <- read_csv('data-raw/MikeWrightCalSimOct2017/cvpia_calsim_nodes.csv', skip = 1)
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


# total diverted------------------------------------
temp_diver <- div_calsim %>%
  mutate(`Upper Sacramento River` = D104 / C104,
         `Antelope Creek` = ifelse(C11307 == 0, 0, (C11307 / (C11307 + C11308 + C11309) * D11305)),
         `Battle Creek` = NA,
         `Bear Creek` = NA,
         `Big Chico Creek` = NA,
         `Butte Creek` = (C217B + D217),
         `Clear Creek` = NA,
         `Cottonwood Creek` = NA,
         `Cow Creek` = NA,
         `Deer Creek` = ifelse(C11309 == 0 ,0, (C11309 / (C11307 + C11308 + C11309) * D11305)),
         `Elder Creek` = ifelse(C11303 == 0, 0, (C11303 / (C11303 + C11304) * D11301)),
         `Mill Creek` = ifelse(C11308 == 0, 0, (C11308 / (C11307 + C11308 + C11309) * D11305)),
         `Paynes Creek` = NA,
         `Stony Creek` = D17301,
         `Thomes Creek` = ifelse(C11304 == 0, 0, (C11304 / (C11303 + C11304) * D11301)),
         `Upper-mid Sacramento River` = (D109 + D112 + D113A + D113B + D114 + D118 + D122A + D122B
                                         + D123 + D124A + D128_WTS + D128),
         `Sutter Bypass` = NA,
         `Bear River` = D285,
         `Feather River` = (D201 + D202 + D7A + D7B),
         `Yuba River` = D230,
         `Lower-mid Sacramento River` = (D129A + D134 + D162 + D165),
         `Yolo Bypass` = NA,
         `American River` = D302,
         `Lower Sacramento River` = (D167 + D168 + D168A_WTS),
         `Calaveras River` = (D506A + D506B + D506C + D507),
         `Cosumnes River` = NA,
         # `Mokelumne River` = NA, # other run from mike U ebmud
         `Merced River` = (D562 + D566),
         `Stanislaus River` = D528,
         `Tuolumne River` = D545,
         `San Joaquin River` = (D637 + D630B + D630A + D620B)) %>%
  select(date, watersheds[-27])

# bring in Moke diversions from other model run
moke <- read_excel('data-raw/EBMUDSIM/CVPIA_SIT_Data_RequestEBMUDSIMOutput_ExCond.xlsx',
                   sheet = 'Tableau Clean-up') %>%
  mutate(date = as_date(Date), `Mokelumne River` = (D503A + D503B + D503C + D502A + D502B)) %>%
  select(date, `Mokelumne River`)

total_diverted <- temp_diver %>%
  left_join(moke) %>%
  select(date:`Cosumnes River`, `Mokelumne River`, `Merced River`:`San Joaquin River`) %>%
  filter(year(date) >= 1980, year(date) <= 2000) %>%
  gather(watershed, tot_diver, -date) %>%
  spread(date, tot_diver) %>%
  left_join(cvpiaFlow::watershed_ordering) %>%
  mutate_all(~replace_na(., 0)) %>%
  arrange(order) %>%
  select(-watershed, -order) %>%
  create_SIT_array()

dimnames(total_diverted) <- list(watershed_ordering$watershed, month.abb[1:12], 1980:2000)
usethis::use_data(total_diverted, overwrite = TRUE)

# Replaces upsacQ
# flow at Bend C109, CALSIMII units cfs, sit-model units cms
upper_sacramento_flows <- misc_flows %>%
  select(date, upsacQcfs = C109) %>%
  mutate(upsacQcms = cvpiaFlow::cfs_to_cms(upsacQcfs)) %>%
  mutate(year = year(date), month = month(date)) %>%
  filter(year >= 1980, year <= 2000) %>%
  select(-date, -upsacQcfs) %>%
  spread(year, upsacQcms) %>%
  select(-month) %>%
  as.matrix()

rownames(upper_sacramento_flows) <- month.abb[1:12]
usethis::use_data(upper_sacramento_flows, overwrite = TRUE)

# Replaces retQ
# proportion flows at tributary junction coming from natal watershed using october average flow
# create lookup vector for retQ denominators based on Jim's previous input
tributary_junctions <- c(rep(watersheds[16], 16), NA, watersheds[19], watersheds[21], watersheds[19],
                  watersheds[21], NA, rep(watersheds[24],2), watersheds[25:27], rep(watersheds[31],4))

names(tributary_junctions) <- watersheds

denominator <- cvpiaFlow::flows_cfs %>%
  select(-`Lower-mid Sacramento River1`) %>% #Feather river comes in below Fremont Weir use River2 for Lower-mid Sac
  rename(`Lower-mid Sacramento River` = `Lower-mid Sacramento River2`) %>%
  gather(watershed, flow, -date) %>%
  filter(month(date) == 10, watershed %in% unique(tributary_junctions)) %>%
  rename(denominator = watershed, junction_flow = flow)

proportion_flow_natal <- cvpiaFlow::flows_cfs %>%
  select(-`Lower-mid Sacramento River1`) %>% #Feather river comes in below Fremont Weir use River2 for Lower-mid Sac
  rename(`Lower-mid Sacramento River` = `Lower-mid Sacramento River2`) %>%
  gather(watershed, flow, -date) %>%
  filter(month(date) == 10) %>%
  mutate(denominator = tributary_junctions[watershed]) %>%
  left_join(denominator) %>%
  mutate(retQ = ifelse(flow / junction_flow > 1, 1, flow / junction_flow),
         retQ = replace(retQ, watershed %in% c('Calaveras River', 'Cosumnes River', 'Mokelumne River'), 1)) %>%
  select(watershed, date, retQ) %>%
  mutate(year = year(date)) %>%
  filter(year >= 1979, year <= 2000) %>%
  select(watershed, year, retQ) %>%
  bind_rows(tibble(
    year = 1979,
    watershed = c('Yolo Bypass', 'Sutter Bypass'),
    retQ = 0
  )) %>%
  spread(year, retQ) %>%
  left_join(cvpiaData::watershed_ordering) %>%
  arrange(order) %>%
  mutate_all(~replace_na(., 0)) %>%
  select(-order, -watershed) %>%
  as.matrix()

rownames(proportion_flow_natal) <- watersheds

usethis::use_data(proportion_flow_natal, overwrite = TRUE)

# Replaces prop.pulse
prop_pulse_flows <- cvpiaFlow::flows_cfs %>%
  filter(between(year(date), 1980, 1999)) %>%
  mutate(`Lower-mid Sacramento River` = 35.6/58 * `Lower-mid Sacramento River1` + 22.4/58 *`Lower-mid Sacramento River2`) %>%
  select(-`Lower-mid Sacramento River1`, -`Lower-mid Sacramento River2`) %>%
  gather(watershed, flow, -date) %>%
  group_by(month = month(date), watershed) %>%
  summarise(prop_pulse = sd(flow)/median(flow)/100) %>% # TODO why divide by 100?
  mutate(prop_pulse = replace(prop_pulse, is.infinite(prop_pulse), 0)) %>%
  select(month, watershed, prop_pulse) %>%
  bind_rows(tibble(
    month = rep(1:12, 2),
    watershed = rep(c('Yolo Bypass', 'Sutter Bypass'), each = 12),
    prop_pulse = 0
  )) %>%
  spread(month, prop_pulse) %>%
  left_join(cvpiaData::watershed_ordering) %>%
  arrange(order) %>%
  select(-order, -watershed) %>%
  as.matrix()

colnames(prop_pulse_flows) <- month.abb[1:12]
rownames(prop_pulse_flows) <- cvpiaFlow::watershed_ordering$watershed

usethis::use_data(prop_pulse_flows, overwrite = TRUE)

# DELTA ----
#  C400 flow at freeport
# 1) daily discharge of the Sacramento River at Freeport
# 2) an indicator variable for whether the DCC is open (1) or closed (0).
# Replaces dlt.gates
delta_cross_channel_closed <- read_csv('data-raw/DeltaCrossChannelTypicalOperations.csv', skip = 2) %>%
  mutate(Month = which(month.name == Month), prop_days_closed = `Days Closed` / days_in_month(Month)) %>%
  select(month = Month, days_closed = `Days Closed`, prop_days_closed) %>%
  gather(metric, value, -month) %>%
  spread(month, value) %>%
  select(-metric) %>%
  as.matrix()

colnames(delta_cross_channel_closed) <- month.abb[1:12]
rownames(delta_cross_channel_closed) <- c('count', 'proportion')

usethis::use_data(delta_cross_channel_closed, overwrite = TRUE)

# delta flows and diversions --------------------
# North Delta inflows: C400 + C157
# South Delta inflow: C401B + C504 + C508 + C644
# North Delta diversions: D403A + D403B + D403C + D403D + D404
# South Delta diversions: D418 + D419 + D412 + D410 + D413 + D409B + D416 + D408_OR + D408_VC
delta_flows <- calsim %>%
  select(date, C400, C157, C401B, C504, C508, C644, D403A, D403B, D403C, D403D,
         D404, D418, D419, D412, D410, D413, D409B, D416, D408_OR, D408_VC) %>%
  mutate(n_dlt_inflow_cfs = C400 + C157,
         s_dlt_inflow_cfs = C401B + C504 + C508 + C644,
         n_dlt_div_cfs =  D403A + D403B + D403C + D403D + D404,
         s_dlt_div_cfs = D418 + D419 + D412 + D410 + D413 + D409B + D416 + D408_OR + D408_VC,
         n_dlt_div_cms = cvpiaFlow::cfs_to_cms(n_dlt_div_cfs),
         s_dlt_div_cms = cvpiaFlow::cfs_to_cms(s_dlt_div_cfs),
         n_dlt_prop_div = n_dlt_div_cfs / n_dlt_inflow_cfs,
         s_dlt_prop_div = s_dlt_div_cfs / s_dlt_inflow_cfs,
         s_dlt_prop_div = ifelse(s_dlt_prop_div > 1, 1, s_dlt_prop_div)) %>%
  select(date,
         n_dlt_inflow_cfs,
         s_dlt_inflow_cfs,
         n_dlt_inflow_cms,
         s_dlt_inflow_cms,
         n_dlt_div_cfs,
         s_dlt_div_cfs,
         n_dlt_div_cms,
         s_dlt_div_cms,
         n_dlt_prop_div,
         s_dlt_prop_div)

usethis::use_data(delta_flows, overwrite = TRUE)

# delta inflows
# Replaces Dlt.inf
inflow <- delta_flows %>%
  filter(year(date) >= 1980, year(date) <= 1999) %>%
  mutate(n_dlt_inflow_cms = cvpiaFlow::cfs_to_cms(n_dlt_inflow_cfs),
         s_dlt_inflow_cms = cvpiaFlow::cfs_to_cms(s_dlt_inflow_cfs)) %>%
  select(date, n_dlt_inflow_cms, s_dlt_inflow_cms) %>%
  gather(delta, inflow, -date) %>%
  spread(date, inflow) %>%
  select(-delta)

delta_inflow <- array(NA, dim = c(12, 20, 2))
delta_inflow[ , , 1] <- as.matrix(inflow[1, ])
delta_inflow[ , , 2] <- as.matrix(inflow[2, ])

dimnames(delta_inflow) <- list(month.abb[1:12], 1980:1999, c('North Delta', 'South Delta'))

usethis::use_data(delta_inflow, overwrite = TRUE)

# delta prop diverted
# Replaces dlt.divers
dl_prop_div <- delta_flows %>%
  filter(year(date) >= 1980, year(date) <= 2000) %>%
  select(date, n_dlt_prop_div, s_dlt_prop_div) %>%
  gather(delta, prop_div, -date) %>%
  spread(date, prop_div) %>%
  select(-delta)

delta_proportion_diverted <- array(NA, dim = c(12, 21, 2))
delta_proportion_diverted[ , , 1] <- as.matrix(dl_prop_div[1, ])
delta_proportion_diverted[ , , 2] <- as.matrix(dl_prop_div[2, ])

dimnames(delta_proportion_diverted) <- list(month.abb[1:12], 1980:2000, c('North Delta', 'South Delta'))

usethis::use_data(delta_proportion_diverted, overwrite = TRUE)

# delta total diversions
# Replaces dlt.divers.tot
dl_tot_div <- delta_flows %>%
  filter(year(date) >= 1980, year(date) <= 2000) %>%
  select(date, n_dlt_div_cms, s_dlt_div_cms) %>%
  gather(delta, tot_div, -date) %>%
  spread(date, tot_div) %>%
  select(-delta)

delta_total_diverted <- array(NA, dim = c(12, 21, 2))
delta_total_diverted[ , , 1] <- as.matrix(dl_tot_div[1, ])
delta_total_diverted[ , , 2] <- as.matrix(dl_tot_div[2, ])

dimnames(delta_total_diverted) <- list(month.abb[1:12], 1980:2000, c('North Delta', 'South Delta'))

usethis::use_data(delta_total_diverted, overwrite = TRUE)

# bypasses -------------

# Replaces prop.Q.bypasses
bypass_prop_flow <- misc_flows %>%
  mutate(yolo = D160/C134,
         sutter = (D117 + D124 + D125 + D126)/C116,
         year = year(date), month = month(date)) %>%
  select(month, year, yolo, sutter) %>%
  filter(between(year, 1980, 2000)) %>%
  gather(bypass, prop_flow, -month, -year) %>%
  spread(year, prop_flow) %>%
  arrange(bypass, month) %>%
  select(-month, -bypass) %>%
  as.matrix()

proportion_flow_bypasses <- array(NA, dim = c(12, 21, 2))
dimnames(proportion_flow_bypasses) <- list(month.abb[1:12], 1980:2000, c('Sutter Bypass', 'Yolo Bypass'))
proportion_flow_bypasses[ , , 1] <- bypass_prop_flow[1:12, ]
proportion_flow_bypasses[ , , 2] <- bypass_prop_flow[13:24, ]

usethis::use_data(proportion_flow_bypasses, overwrite = TRUE)
