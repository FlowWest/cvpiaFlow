#' Convert flow from cfs to cms
#'
#' @param flow_cfs flow in cubic feet per second
#' @return \code{flow_cfs} in cubic meters per second
#' @export
cfs_to_cms <- function(flow_cfs) {
  flow_cfs * 0.028316847
}
