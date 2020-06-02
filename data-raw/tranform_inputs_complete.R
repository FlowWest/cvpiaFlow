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
dl_prop_div <- cvpiaFlow::delta_flows %>%
  filter(year(date) >= 1980, year(date) <= 2000) %>%
  select(date, n_dlt_prop_div, s_dlt_prop_div) %>%
  gather(delta, prop_div, -date) %>%
  spread(date, prop_div)

dlt_divers <- array(NA, dim = c(12, 21, 2))
dlt_divers[ , , 1] <- as.matrix(dl_prop_div[1, -1])
dlt_divers[ , , 2] <- as.matrix(dl_prop_div[2, -1])

# usethis::use_data(dlt_divers, overwrite = TRUE)

# delta total diversions
dl_tot_div <- cvpiaFlow::delta_flows %>%
  filter(year(date) >= 1980, year(date) <= 2000) %>%
  select(date, n_dlt_div_cms, s_dlt_div_cms) %>%
  gather(delta, tot_div, -date) %>%
  spread(date, tot_div)

dlt_divers_tot <- array(NA, dim = c(12, 21, 2))
dlt_divers_tot[ , , 1] <- as.matrix(dl_tot_div[1, -1])
dlt_divers_tot[ , , 2] <- as.matrix(dl_tot_div[2, -1])

# usethis::use_data(dlt_divers_tot, overwrite = TRUE)
