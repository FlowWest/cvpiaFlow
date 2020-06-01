
# Tributaries and Mainstems -----
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
