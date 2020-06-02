library(dplyr)
library(tidyr)
library(lubridate)
#' Generate SIT Model Compatible Array
#' @description transforms to array data structure for SIT model input
#' @name create_Sit_array
#' @param input a vector of data, length = 252 for 12 months and 20 years of data
#' @return 3 dimension array [location, month, year]
#' @export
create_SIT_array <- function(input) {

  output <- array(NA, dim = c(nrow(input), 12, ncol(input) / 12))
  index <-  1
  for (i in seq(1, ncol(input), 12)) {
    output[ , , index] <- as.matrix(input[ , i:(i + 11)])
    index <- index + 1
  }
  return(output)

}

# using bypass node that is activated the most for meanQ
bypass <- cvpiaFlow::bypass_flows %>%
  select(date, `Sutter Bypass` = sutter4, `Yolo Bypass` = yolo2)

meanQ <- cvpiaFlow::flows_cfs %>%
  left_join(bypass) %>%
  filter(between(year(date), 1980, 2000)) %>%
  gather(watershed, flow_cfs, -date) %>%
  filter(watershed != 'Lower-mid Sacramento River1') %>%
  mutate(flow_cms = cvpiaFlow::cfs_to_cms(flow_cfs),
         watershed = ifelse(watershed == 'Lower-mid Sacramento River2', 'Lower-mid Sacramento River', watershed)) %>%
  select(-flow_cfs) %>%
  spread(date, flow_cms) %>%
  left_join(cvpiaData::watershed_ordering) %>%
  arrange(order) %>%
  select(-watershed, -order) %>%
  create_SIT_array()

dim(meanQ) # 21 years

# usethis::use_data(meanQ, overwrite = TRUE)

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

total_diversion <- cvpiaFlow::total_diverted %>%
  filter(year(date) >= 1980, year(date) <= 2000) %>%
  gather(watershed, tot_diver, -date) %>%
  mutate(tot_diver = ifelse(is.na(tot_diver), 0, tot_diver)) %>%
  spread(date, tot_diver) %>%
  left_join(cvpiaData::watershed_ordering) %>%
  arrange(order) %>%
  select(-watershed, -order) %>%
  create_SIT_array()

dim(total_diversion)

# usethis::use_data(total_diversion, overwrite = TRUE)

# bypass flows for rearing habitat
bp_pf <- cvpiaFlow::propQbypass %>%
  select(-propQyolo, -propQsutter) %>%
  filter(between(year(date), 1980, 2000)) %>%
  gather(bypass, flow, -date) %>%
  spread(date, flow)

bypass_prop_Q <- array(NA, dim = c(12, 21, 6))
for (i in 1:6) {
  bypass_prop_Q[ , , i] <- as.matrix(bp_pf[i, -1])
}

dim(bypass_prop_Q)

# usethis::use_data(bypass_prop_Q, overwrite = TRUE)

returnQ <- cvpiaFlow::return_flow %>%
  mutate(year = year(date)) %>%
  filter(year >= 1979, year <= 2000) %>%
  select(watershed, year, retQ) %>%
  mutate(retQ = ifelse(is.na(retQ), 0, retQ)) %>%
  spread(year, retQ) %>%
  left_join(cvpiaData::watershed_ordering) %>%
  arrange(order) %>%
  select(-order)

# usethis::use_data(returnQ, overwrite = TRUE)

upsac_flow <- cvpiaFlow::upsacQ %>%
  mutate(year = year(date), month = month(date)) %>%
  filter(year >= 1980, year <= 2000) %>%
  select(-date, -upsacQcfs) %>%
  spread(year, upsacQcms) %>%
  select(-month)

# usethis::use_data(upsac_flow, overwrite = TRUE)



# usethis::use_data(bypass_over, overwrite = TRUE)


# flow at freeport
# TODO freeport_flows <- calib_data$Q_free, is calib_data$Q_free the same?
freeportQcms <- cvpiaFlow::freeportQ %>%
  mutate(year = year(date), month = month(date)) %>%
  filter(year >= 1980, year <= 1999) %>%
  select(-date, -freeportQcfs) %>%
  spread(year, freeportQcms) %>%
  select(-month) %>%
  as.matrix()

rownames(freeportQcms) <- month.abb[1:12]

usethis::use_data(freeportQcms, overwrite = TRUE)




