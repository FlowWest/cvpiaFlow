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
