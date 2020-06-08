
# Tributaries and Mainstems -----
#' Upper Sacramento River Flow
#' @description A dataset containing the Upper Sacramento River flow in cubic meters per second
#'
#' @format a 12 by 21 matrix (month by year)
#'
#' @details The Upper Sacramento River is represented using node CALSIM II 'FLOW-CHANNEL' C109 node at Bend.
#' Each row represents a month, each column a year from 1980-2000.
#' This data is used to route fish into the delta.
#'
#' \href{https://s3-us-west-2.amazonaws.com/cvpiaflow-r-package/BST_CALSIMII_schematic_040110.jpg}{CALSIM II schematic}
#'
#' @source
#' \itemize{
#'   \item \strong{Data Wrangling:} Sadie Gill  \email{sgill@@flowwest.com}
#'   \item \strong{Node Selection:} Mark Tompkins \email{mtompkins@@flowwest.com} and Mike Urkov \email{mike.urkov@@gmail.com}
#'   \item \strong{CALSIM Model Output:} Michael Wright \email{mwright@@usbr.gov}
#' }
#'
#'
"upper_sacramento_flows"

#' Return Flow
#' @description A dataset containing the proportion flows at tributary junction
#' coming from natal watershed using October CALSIM II flows. These proportions are used to estimate
#' straying in the CVPIA SIT Salmon Population Model.
#'
#' @format 31 by 22 matrix (watersheds by years 1979-2000):
#'
#' @details The return flow proportion is calculated using the average October flow
#' in each watershed divided by the average October flow of the tributary it flows
#' into for each year of the simulation. These tributary relationships
#' are described in detail below.
#'
#'
#' \strong{Flow into Upper-mid Sacramento River:}
#' \itemize{
#'   \item Upper Sacramento River
#'   \item Antelope Creek
#'   \item Battle Creek
#'   \item Bear Creek
#'   \item Big Chico Creek
#'   \item Butte Creek
#'   \item Clear Creek
#'   \item Cottonwood Creek
#'   \item Cow Creek
#'   \item Deer Creek
#'   \item Elder Creek
#'   \item Mill Creek
#'   \item Paynes Creek
#'   \item Stony Creek
#'   \item Thomes Creek
#' }
#'
#' \strong{Flow into Feather River:}
#' \itemize{
#'   \item Bear River
#'   \item Yuba River
#' }
#'
#' \strong{Flow into Lower-mid Sacramento River:}
#' \itemize{
#'   \item Feather River
#' }
#'
#' \strong{Flow into Lower Sacramento River:}
#' \itemize{
#'   \item American River
#' }
#'
#' \strong{Flow into San Joaquin River:}
#' \itemize{
#'   \item Merced River
#'   \item Tuolumne River
#'   \item Stanislaus River
#' }
#'
#' The Mokulumne River, Calaveras River, and Cosumnes River are assigened 100\%.
#'
#'
#' \href{https://s3-us-west-2.amazonaws.com/cvpiaflow-r-package/BST_CALSIMII_schematic_040110.jpg}{CALSIM II schematic}
#'
#' @source
#' \itemize{
#'   \item \strong{Data Wrangling:} Sadie Gill  \email{sgill@@flowwest.com}
#'   \item \strong{Node Selection:} Mark Tompkins \email{mtompkins@@flowwest.com} and Mike Urkov \email{mike.urkov@@gmail.com}
#'   \item \strong{CALSIM Model Output:} Michael Wright \email{mwright@@usbr.gov}
#' }
#'
#' Calculated using \code{\link{flows_cfs}}
#'
"prop_flow_natal"

# TODO not sure what units this should be or description because of /100,
# replaces prop.pulse
#' Proportion Pulse Flow
#' @description Estimated monthly proportion of flow that is a pulse
#' @format a 31 by 12 matrix (watersheds by months)
#' @details prop_pulse_flows = sd(flow)/median(flow)/100
#'
#' Calculated using \code{\link{flows_cfs}}
#'
"prop_pulse_flows"

# Bypasses ------

# Delta -----
#' Delta Cross Channel Operations
#' @description The number of days and proportion of days the Delta Cross Channel
#' gates are typically closed for each month
#' @format a 2 by 12 matrix, row one and two are the count and proportion of days
#' closed respectively, columns are months
#' @details By rule, 45 days between November-January, based on real time monitoring.
#' For modeling purposes, the days closed where divided between December and January.
#'
#' Note: Some real-time changes possible based on:
#' \itemize{
#'  \item fish monitoring
#'  \item interior delta salinity
#'  \item flood operations
#' }
#'
#' In May, typically open for Memorial Day.
#'
#' @source \href{http://www.westcoast.fisheries.noaa.gov/central_valley/water_operations/ocap.html}{2009 NMFS BiOp Action IV.1 and D-1641}
#'
#' Compiled by Mike Urkov \email{mike.urkov@@gmail.com}
#'
"delta_cross_channel_closed"

#' Delta Flows and Diversions
#' @description A dataset containing the inflow, total diversions, and proportion
#' diverted for the North and South Deltas.
#'
#' @format dataframe with 972 rows and 9 variables:
#' \describe{
#' \item{date}{CALSIM II date}
#' \item{n_dlt_inflow_cfs}{C400 + C157, north delta inflow in cubic feet per second}
#' \item{s_dlt_inflow_cfs}{C401B + C504 + C508 + C644, south delta inflow in cubic feet per second}
#' \item{n_dlt_div_cfs}{D403A + D403B + D403C + D403D + D404, north delta diversions in cubic feet per second}
#' \item{s_dlt_div_cfs}{D418 + D419 + D412 + D410 + D413 + D409B + D416 + D408_OR + D408_VC, south delta diversions in cubic feet per second}
#' \item{n_dlt_div_cms}{north delta diversions in cubic meters per second}
#' \item{s_dlt_div_cms}{south delta diversions in cubic meters per second}
#' \item{n_dlt_prop_div}{north delta diversions / north delta inflow}
#' \item{s_dlt_prop_div}{south delta diversions / south delta inflow}
#' }
#'
#' @details The inflow, diversions, and proportions diverted in the North and South
#' Deltas are represented using 'FLOW-CHANNEL' and 'FLOW-DELIVERY' nodes from CALSIM II.
#'
#' The North Delta is defined as the area west of and including the Sacramento River
#' below Freeport to Chips Island.
#'
#' The South Delta is defined as the area east of the Sacramento River below Freeport
#' to Chips Island and the San Joaquin River below Vernalis. The nodes and calculation
#' for each delta are outlined above.
#'
#'
#' \href{https://s3-us-west-2.amazonaws.com/cvpiaflow-r-package/BST_CALSIMII_schematic_040110.jpg}{CALSIM II schematic}
#'
#' @source
#' \itemize{
#'   \item \strong{Data Wrangling:} Sadie Gill  \email{sgill@@flowwest.com}
#'   \item \strong{Node Selection:} Mark Tompkins \email{mtompkins@@flowwest.com} and Mike Urkov \email{mike.urkov@@gmail.com}
#'   \item \strong{CALSIM Model Output:} Michael Wright \email{mwright@@usbr.gov}
#' }
#'
"delta_flows"

#' Delta Inflow
#' @description The delta inflow in cubic meters per second from 1980-1999.
#'
#' @format A 3 dimensional array: 12 by 20 by 2 (months, years, deltas)
#'
#' [ , , 1] North Delta
#'
#' [ , , 2] South Delta
#'
#' @details
#' The North Delta is defined as the area west of and including the Sacramento River
#' below Freeport to Chips Island.
#'
#' The South Delta is defined as the area east of the Sacramento River below Freeport
#' to Chips Island and the San Joaquin River below Vernalis.
#'
#' Calculated using \code{\link{delta_flows}}
#'
"delta_inflow"

#' Delta Proportion Diverted
#' @description The proportion of delta inflow diverted from 1980-2000.
#'
#' @format A 3 dimensional array: 12 by 21 by 2 [months, years, deltas]
#'
#' [ , , 1] North Delta
#'
#' [ , , 2] South Delta
#'
#' @details
#' The North Delta is defined as the area west of and including the Sacramento River below Freeport to Chips Island.
#'
#' The South Delta is defined as the area east of the Sacramento River below Freeport to Chips Island and the San Joaquin River
#' below Vernalis.
#'
#' Calculated using \code{\link{delta_flows}}
#'
"delta_proportion_diverted"

#' Delta Total Diverted
#' @description The total diverted of delta inflow in cubic meters per second from 1980-2000.
#'
#' @format A 3 dimensional array: 12 by 21 by 2 (months, years, deltas)
#'
#' [ , , 1] North Delta
#'
#' [ , , 2] South Delta
#'
#' @details
#' The North Delta is defined as the area west of and including the Sacramento River below Freeport to Chips Island.
#'
#' The South Delta is defined as the area east of the Sacramento River below Freeport to Chips Island and the San Joaquin River
#' below Vernalis.
#'
#' Calculated using \code{\link{delta_flows}}
#'
"delta_total_diverted"
