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
* bypass_over - was gate.top in model, not used
```
#' Sutter and Yolo Bypasses Overtopped
#' @description A dataset containing a boolean representation of bypasses overtopped
#' used for adult pre-spawning survival.
#'
#' @format dataframe with 252 rows and 3 variables:
#' \describe{
#' \item{date}{CALSIM II date}
#' \item{sutter}{TRUE if D117 + D124 + D125 + D126 + C137 >= 100 cfs}
#' \item{yolo}{TRUE if D160 + C157 >= 100 cfs}
#' }
#'
#' @details The flow upstream and down stream of the bypasses are represented using
#' 'FLOW-CHANNEL' and 'FLOW-DELIVERY' nodes from CALSIM II.
#' The nodes for each watershed are outlined above. If the flow into the bypasses is
#' greater than 100 cfs the bypass is considered overtopped.
#'
#'
#' \href{https://s3-us-west-2.amazonaws.com/cvpiaflow-r-package/BST_CALSIMII_schematic_040110.jpg}{CALSIM II schematic}
#'
#' @source
#' \itemize{
#'   \item \strong{Data Wrangling:} Sadie Gill  \email{sgill@@flowwest.com}
#'   \item \strong{Node Selection:} Mark Tompkins \email{mtompkins@@flowwest.com}
#'   \item \strong{CALSIM Model Output:} Michael Wright \email{mwright@@usbr.gov}
#' }
#'
"bypass_overtopped"

# bypass overtopped --------------------
# overtopped is > 100 cfs
bypass_overtopped <- calsim %>%
  mutate(sutter = D117 + D124 + D125 + D126 + C137,
         yolo = D160 + C157) %>%
  select(date, sutter, yolo) %>%
  filter(between(year(date), 1979, 1999)) %>%
  gather(bypass, flow, - date) %>%
  mutate(overtopped = flow >= 100) %>%
  select(-flow) %>%
  spread(bypass, overtopped)

use_data(bypass_overtopped)

d <- 1:12
names(d) <- month.name

# yolo and sutter(includes tisdale) overtopping
# flow in bypass for adults is 1
# bypass_over_top <-
bpo <- cvpiaFlow::bypass_overtopped %>%
  gather(bypass, overtopped, -date) %>%
  spread(date, overtopped)

sutter_overtopped <- cvpiaFlow::bypass_overtopped %>%
  filter(between(year(date), 1980, 1999)) %>%
  gather(bypass, overtopped, -date) %>%
  filter(bypass == "sutter") %>%
  mutate(month = month(date),
         year = year(date)) %>%
  select(-date, -bypass) %>%
  spread(year, overtopped) %>%
  arrange(month) %>%
  select(-month) %>%
  as.matrix()

yolo_overtopped <- cvpiaFlow::bypass_overtopped %>%
  filter(between(year(date), 1980, 1999)) %>%
  gather(bypass, overtopped, -date) %>%
  filter(bypass == "yolo") %>%
  mutate(month = month(date),
         year = year(date)) %>%
  select(-date, -bypass) %>%
  spread(year, overtopped) %>%
  arrange(month) %>%
  select(-month) %>%
  as.matrix()

bypass_over <- array(as.logical(NA), dim = c(12, 20, 2))
bypass_over[ , , 1] <- sutter_overtopped
bypass_over[ , , 2] <- yolo_overtopped
# usethis::use_data(bypass_over, overwrite = TRUE)
```
