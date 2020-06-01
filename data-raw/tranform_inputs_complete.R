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
  select(-order, - watershed) %>%
  as.matrix()

colnames(prop_pulse_flows) <- month.abb[1:12]
rownames(prop_pulse_flows) <- cvpiaFlow::watershed_ordering$watershed

usethis::use_data(prop_pulse_flows, overwrite = TRUE)


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

# delta inflows
# Replaces Dlt.inf
dlt_inflow <- cvpiaFlow::delta_flows %>%
  filter(year(date) >= 1980, year(date) <= 1999) %>%
  select(date, n_dlt_inflow_cms, s_dlt_inflow_cms) %>%
  gather(delta, inflow, -date) %>%
  spread(date, inflow)

dlt_inflow <- array(NA, dim = c(12, 20, 2))
dlt_inflow[ , , 1] <- as.matrix(dl_inflow[1, -1])
dlt_inflow[ , , 2] <- as.matrix(dl_inflow[2, -1])

# usethis::use_data(dlt_inflow, overwrite = TRUE)
