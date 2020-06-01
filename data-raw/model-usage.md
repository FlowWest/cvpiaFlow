## depricate

* med_flow - was medQ in model, not used
```
#' Median Flow
#' @description The monthly median flows of 1980-2000 in cubic feet per second
#' @format a dataframe with 31 rows and 13 variables
#' \describe{
#'   \item{watershed}{CVPIA watershed}
#'   \item{1}{January median flow}
#'   \item{2}{February median flow}
#'   \item{3}{March median flow}
#'   \item{4}{April median flow}
#'   \item{5}{May median flow}
#'   \item{6}{June median flow}
#'   \item{7}{July median flow}
#'   \item{8}{August median flow}
#'   \item{9}{September median flow}
#'   \item{10}{October median flow}
#'   \item{11}{November median flow}
#'   \item{12}{December median flow}
#' }
#' @details
#'
#' Calculated using \code{\link{flows_cfs}}
#'
"med_flow"

med_flow <- cvpiaFlow::flows_cfs %>%
  filter(between(year(date), 1980, 2000)) %>%
  mutate(`Lower-mid Sacramento River` = 35.6/58 * `Lower-mid Sacramento River1` + 22.4/58 *`Lower-mid Sacramento River2`) %>%
  select(-`Lower-mid Sacramento River1`, -`Lower-mid Sacramento River2`) %>%
  gather(watershed, flow, -date) %>%
  group_by(month = month(date), watershed) %>%
  summarise(median_flow = median(flow)) %>%
  # mutate(prop_pulse = replace(prop_pulse, is.infinite(prop_pulse), 0)) %>%
  select(month, watershed, median_flow) %>%
  spread(month, median_flow) %>%
  bind_rows(byp) %>%
  left_join(cvpiaData::watershed_ordering) %>%
  arrange(order) %>%
  select(-order)

# usethis::use_data(med_flow, overwrite = TRUE)
```
