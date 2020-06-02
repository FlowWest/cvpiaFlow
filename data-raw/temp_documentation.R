# NEW STUFF ------
#' Proportion Flow at Yolo and Sutter Bypasses
#' @description The proportion of Lower Sacramento River flow at each bypass weir
#'
#' @format A 3 dimensional array: 12 by 21 by 6 [months, years, bypasses]
#'
#' \itemize{
#'   \item [ , , 1] Sutter Bypass 1
#'   \item [ , , 2] Sutter Bypass 2
#'   \item [ , , 3] Sutter Bypass 3
#'   \item [ , , 4] Sutter Bypass 4
#'   \item [ , , 5] Yolo Bypass 1
#'   \item [ , , 6] Yolo Bypass 2
#' }

#'
#' @details For more details see:
#' \itemize{
#'   \item use this link within R \code{\link[cvpiaFlow]{propQbypass}}
#'   \item use this \href{https://flowwest.github.io/cvpiaFlow/reference/propQbypass.html}{link} if in a web browser
#' }
"bypass_prop_Q"


#' Sutter and Yolo Bypass Over Topped
#' @description  1979-2000 boolean record of the bypasses over topped based on CALSIM flows
#'
#' @format A 3 dimensional array: 12 by 21 by 2 [months, years, bypasses]
#'
#' [ , , 1] Sutter Bypass
#'
#' [ , , 2] Yolo Bypass
#'
#'@details For more details see:
#'\itemize{
#'   \item use this link within R \code{\link[cvpiaFlow]{bypass_overtopped}}
#'   \item use this \href{https://flowwest.github.io/cvpiaFlow/reference/bypass_overtopped.html}{link} if in a web browser
#' }
#' @source Sadie Gill \email{sgill@@flowwest.com}
"bypass_over"

#' Delta Cross Channel Gates - Days Closed
#' @description The number of days the Delta Cross Channel gates are closed for each month based on typical operation.
#' @format dataframe with 12 rows and 2 variables:
#' \describe{
#' \item{month}{Integar representation of months}
#' \item{days_closed}{the number of days the delta cross channel gates are typically closed}
#' \item{prop_days_closed}{the proportion of days during the month that the delta cross channel gates are typically closed}
#' }
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
"cross_channel_gates"


#' Flow at Freeport
#' @description The inflow at Freeport in cubic meters per second from 1980-2000.
#'
#' @format A dataframe with 12 rows and 21 variables
#' Each row represents a month, each column a year from 1980-2000.
#' This data is used to route fish into the delta.
#'
#' @details For more details see:
#'  \itemize{
#'   \item use this link within R \code{\link[cvpiaFlow]{freeportQ}}
#'   \item use this \href{https://flowwest.github.io/cvpiaFlow/reference/freeportQ.html}{link} if in a web browser
#' }
#'
#'
"freeportQcms"

#' Monthly Mean Flow
#' @description The mean flow in cubic meters per second for each watershed every month of every year in the simulation (1980-2000).
#' @format a 3 dimensional array [31 watersheds, 12 months, 21 years]
#' @details For more details see:
#' \itemize{
#'   \item use this link within R \code{\link[cvpiaFlow]{flows_cfs}}
#'   \item use this \href{https://flowwest.github.io/cvpiaFlow/reference/flows_cfs.html}{link} if in a web browser
#' }
"meanQ"

#' Proportion of Flow Diverted
#' @description The proportion of flow diverted for each watershed every month of every year in the simulation (1980-2000).
#' @format a 3 dimensional array [31 watersheds, 12 months, 21 years]
#' @details For more details see:
#' \itemize{
#'   \item use this link within R \code{\link[cvpiaFlow]{proportion_diverted}}
#'   \item use this \href{https://flowwest.github.io/cvpiaFlow/reference/proportion_diverted.html}{link} if in a web browser
#' }
"prop_diversion"

#' Total Flow Diverted
#' @description The total flow diverted in cubic feet per second for each watershed every month of every year in the simulation (1980-2000).
#' @format a 3 dimensional array [31 watersheds, 12 months, 21 years]
#' @details For more details see:
#' \itemize{
#'   \item use this link within R \code{\link[cvpiaFlow]{total_diverted}}
#'   \item use this \href{https://flowwest.github.io/cvpiaFlow/reference/total_diverted.html}{link} if in a web browser
#' }
#'
#'
"total_diversion"

#' Return Flow
#' @description The proportion flows at tributary junction coming from natal watershed using October CALSIM II flows
#' from 1979-1998.
#'
#' @format A dataframe with 12 rows and 23 variables
#'
#' @details
#' Each row represents a month, each column a year from 1979-2000
#'
#' For more details see:
#' \itemize{
#'   \item use this link within R \code{\link[cvpiaFlow]{return_flow}}
#'   \item use this \href{https://flowwest.github.io/cvpiaFlow/reference/return_flow.html}{link} if in a web browser
#' }
#'
"returnQ"




