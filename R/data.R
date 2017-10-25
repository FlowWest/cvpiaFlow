#' Proportion of Flow Diverted
#' @description A dataset containing the proportion of flow diverted within watersheds for
#' use with the CVPIA Science Integration Team Decision Support Model.
#'
#' @format dataframe with 985 rows and 32 variables:
#' \describe{
#' \item{date}{CALSIMII date}
#' \item{Upper Sacramento River}{D104 / C104}
#' \item{Antelope Creek}{(C11307 / (C11307 + C11308 + C11309) * D11305) / C11307}
#' \item{Battle Creek}{no modeled diversions}
#' \item{Bear Creek}{no modeled diversions}
#' \item{Big Chico Creek}{no modeled diversions}
#' \item{Butte Creek}{(C217B + D217) / (C217B + D217 + C217A)}
#' \item{Clear Creek}{no modeled diversions}
#' \item{Cottonwood Creek}{no modeled diversions}
#' \item{Cow Creek}{no modeled diversions}
#' \item{Deer Creek}{(C11309 / (C11307 + C11308 + C11309) * D11305) / C11309}
#' \item{Elder Creek}{(C11303 / (C11303 + C11304) * D11301) / C11303}
#' \item{Mill Creek}{(C11308 / (C11307 + C11308 + C11309) * D11305) / C11308}
#' \item{Paynes Creek}{no modeled diversions}
#' \item{Stony Creek}{D17301 / C42}
#' \item{Thomes Creek}{(C11304 / (C11303 + C11304) * D11301) / C11304}
#' \item{Upper-mid Sacramento River}{(D109 + D112 + D113A + D113B + D114 + D118 + D122A + D122B + D123 + D124A + D128_WTS + D128) / C110}
#' \item{Sutter Bypass}{no modeled diversions}
#' \item{Bear River}{D285 / (C285 + D285)}
#' \item{Feather River}{(D201 + D202 + D7A + D7B) / C6}
#' \item{Yuba River}{D230 / (C230 + D230)}
#' \item{Lower-mid Sacramento River}{(D129A + D134 + D162 + D163 + D165) / C128}
#' \item{Yolo Bypass}{no modeled diversions}
#' \item{American River}{D302 / C9}
#' \item{Lower Sacramento River}{(D167 + D168 + D168A_WTS) / C166}
#' \item{Calaveras River}{(D506A + D506B + D506C + D507) / C92}
#' \item{Cosumnes River}{no modeled diversions}
#' \item{Mokelumne River}{(D503A + D503B + D503C + D502A + D502B) / C91*}
#' \item{Merced River}{(D562 + D566) / C561}
#' \item{Stanislaus River}{D528 / C520}
#' \item{Tuolumne River}{D545 / C540}
#' \item{San Joaquin River}{(D637 + D630B + D630A + D620B) / (D637 + D630B + D630A + D620B + C637)}
#' }
#'
#' @details The proportion diverted was calculated using 'FLOW-CHANNEL' and 'FLOW-DELIVERY' nodes from CALSIMII.
#' The nodes and calculation for each watershed are outlined above.
#'
#' *Mokelumne River flow and diversions are from a separate model provided by EBMUD.
#'
#' \href{}{CALSIMII schematic}
#'
#' @source
#' \itemize{
#'   \item \strong{Data Wrangling:} Sadie Gill  \email{sgill@@flowwest.com}
#'   \item \strong{Node Selection:} Mark Tompkins \email{mtompkins@@flowwest.com} and Mike Urkov \email{mike.urkov@@gmail.com}
#'   \item \strong{CALSIM Model Output:} Michael Wright \email{mwright@@usbr.gov}
#' }
#'
"proportion_diverted"

#' Flow
#' @description A dataset containing the flow in cfs within watersheds for
#' use with the CVPIA Science Integration Team Decision Support Model to develope habitat inputs.
#'
#' @format dataframe with 985 rows and 33 variables:
#' \describe{
#' \item{date}{CALSIMII date}
#' \item{Upper Sacramento River}{C104}
#' \item{Antelope Creek}{C11307}
#' \item{Battle Creek}{C10803}
#' \item{Bear Creek}{C11001}
#' \item{Big Chico Creek}{C11501}
#' \item{Butte Creek}{C217A}
#' \item{Clear Creek}{C3}
#' \item{Cottonwood Creek}{C10802}
#' \item{Cow Creek}{C10801}
#' \item{Deer Creek}{C11309}
#' \item{Elder Creek}{C11303}
#' \item{Mill Creek}{C11308}
#' \item{Paynes Creek}{C11001}
#' \item{Stony Creek}{C142A}
#' \item{Thomes Creek}{C11304}
#' \item{Upper-mid Sacramento River}{C115}
#' \item{Sutter Bypass}{D117 + D124 + D125 + D126}
#' \item{Bear River}{C285}
#' \item{Feather River}{C203}
#' \item{Yuba River}{C230}
#' \item{Lower-mid Sacramento River1}{C134}
#' \item{Lower-mid Sacramento River2}{C160}
#' \item{Yolo Bypass}{C157}
#' \item{American River}{C9}
#' \item{Lower Sacramento River}{C166}
#' \item{Calaveras River}{C92}
#' \item{Cosumnes River}{C501}
#' \item{Mokelumne River}{C91*}
#' \item{Merced River}{C561}
#' \item{Stanislaus River}{C520}
#' \item{Tuolumne River}{C540}
#' \item{San Joaquin River}{C630}
#' }
#'
#' @details The flow is represented using 'FLOW-CHANNEL' and 'FLOW-DELIVERY' nodes from CALSIMII.
#' The nodes and calculation for each watershed are outlined above.
#'
#' The Lower-mid Sacramento River has two nodes, one above Fremont Weir (C134) and one below (C160).
#' When calculating habitat for the Lower-Mid Sacramento river, calculate the habitat at each flow node and
#' sum them proportion to the length of stream above and below the weir:
#' \deqn{35.6/58 * (habitat at C134) + 22.4/58 * (habitat at C160)}
#'
#' *Mokelumne River flow is from a separate model provided by EBMUD.
#'
#' \href{}{CALSIMII schematic}
#'
#' @source
#' \itemize{
#'   \item \strong{Data Wrangling:} Sadie Gill  \email{sgill@@flowwest.com}
#'   \item \strong{Node Selection:} Mark Tompkins \email{mtompkins@@flowwest.com} and Mike Urkov \email{mike.urkov@@gmail.com}
#'   \item \strong{CALSIM Model Output:} Michael Wright \email{mwright@@usbr.gov}
#' }
#'
"flows"
