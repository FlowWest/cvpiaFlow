
# Tributaries and Mainstems -----
#' Total Flow Diverted
#' @description A dataset containing the diverted flow in cfs within watersheds for
#' use with the CVPIA SIT Salmon Population Model.
#'
#' @format a 31 by 12 by 21 array [watershed, month, year (1980-2000)]:
#'
#' @details The proportion diverted was calculated using 'FLOW-CHANNEL' and 'FLOW-DELIVERY' nodes from CALSIM II.
#' The nodes and calculation for each watershed are outlined below
#'
#' The diversions of Antelope Creek, Deer Creek and Mill Creek are represented by one diversion node.
#' Diversions for these creeks were estimated in proportion to their flow. Elder Creek and Thomes Creek
#' are also represented with a single node and their diversions were estimated using the same method.
#'
#' \describe{
#'   \item{Upper Sacramento River}{D104}
#'   \item{Antelope Creek}{(C11307 / (C11307 + C11308 + C11309) * D11305)}
#'   \item{Battle Creek}{no modeled diversions}
#'   \item{Bear Creek}{no modeled diversions}
#'   \item{Big Chico Creek}{no modeled diversions}
#'   \item{Butte Creek}{(C217B + D217)}
#'   \item{Clear Creek}{no modeled diversions}
#'   \item{Cottonwood Creek}{no modeled diversions}
#'   \item{Cow Creek}{no modeled diversions}
#'   \item{Deer Creek}{(C11309 / (C11307 + C11308 + C11309) * D11305)}
#'   \item{Elder Creek}{(C11303 / (C11303 + C11304) * D11301)}
#'   \item{Mill Creek}{(C11308 / (C11307 + C11308 + C11309) * D11305)}
#'   \item{Paynes Creek}{no modeled diversions}
#'   \item{Stony Creek}{D17301}
#'   \item{Thomes Creek}{(C11304 / (C11303 + C11304) * D11301)}
#'   \item{Upper-mid Sacramento River}{(D109 + D112 + D113A + D113B + D114 + D118 + D122A + D122B + D123 + D124A + D128_WTS + D128)}
#'   \item{Sutter Bypass}{no modeled diversions}
#'   \item{Bear River}{D285}
#'   \item{Feather River}{(D201 + D202 + D7A + D7B)}
#'   \item{Yuba River}{D230}
#'   \item{Lower-mid Sacramento River}{(D129A + D134 + D162 + D165)}
#'   \item{Yolo Bypass}{no modeled diversions}
#'   \item{American River}{D302}
#'   \item{Lower Sacramento River}{(D167 + D168 + D168A_WTS)}
#'   \item{Calaveras River}{(D506A + D506B + D506C + D507)}
#'   \item{Cosumnes River}{no modeled diversions}
#'   \item{Mokelumne River}{(D503A + D503B + D503C + D502A + D502B)*}
#'   \item{Merced River}{(D562 + D566)}
#'   \item{Stanislaus River}{D528}
#'   \item{Tuolumne River}{D545}
#'   \item{San Joaquin River}{(D637 + D630B + D630A + D620B)}
#' }
#'
#' \emph{*Mokelumne River flow and diversions are from a separate model provided by EBMUD.}
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
"total_diverted"

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
#' Proportion of Sacramento River Flow through the Sutter and Yolo Bypasses
#' @description The monthly proportion of Sacramento River flow within the bypasses
#' (years 1980-2000) for use with the CVPIA SIT Salmon Population Model to
#' apportion fish onto the bypasses.
#'
#' @format a 12 by 21 by 2 array (month, year, bypass):
#' [ , , 1] = Sutter Bypass represented with CALSIM II nodes (D117 + D124 + D125 + D126)/C116
#' [ , , 2] = Yolo Bypass represented with CALSIM II nodes D160/C134
#'
#' @details The proportions of Sacramento River flowing through the bypasses are represented using
#' 'FLOW-CHANNEL' and 'FLOW-DELIVERY' nodes from CALSIM II.
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
"proportion_flow_bypasses"


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
